package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.ds.EntityCollection;
import glaze.engine.components.Position;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.systems.PhysicsCollisionSystem;

class QueryEntitiesInArea extends Behavior {

    var broadphase:IBroadphase;
    var aabb:glaze.geom.AABB;
    var ec:EntityCollection;
    var filterOwner:Bool;

    public function new(range:Float,filterOwner:Bool=true) {
        super();
        aabb = new glaze.geom.AABB();
        // aabb.position = position.coords;
        aabb.extents.setTo(range,range);
        this.filterOwner = filterOwner;
    }

    override private function initialize(context:BehaviorContext):Void {
        aabb.position = context.entity.getComponent(Position).coords;
        broadphase = context.entity.engine.getSystem(PhysicsCollisionSystem).broadphase;
        ec = untyped context.data.ec;
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 

        function addBroadphaseItem(bfproxy:BFProxy) {
            if (filterOwner&&bfproxy.entity==context.entity)
                return;
            var item = ec.addItem(bfproxy.entity);
            item.distance = bfproxy.aabb.position.distSqrd(aabb.position);
            item.perspective = aabb.position;
        }

        broadphase.QueryArea(aabb,addBroadphaseItem);
        // trace(ec.length);
        return Success;
    }


}