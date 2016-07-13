package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.ai.behaviortree.Decorator;
import glaze.ai.steering.behaviors.Arrival;
import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.components.PhysicsCollision;

class InRangeTarget extends Behavior {

    public function new() {
        super();
    }

    override private function initialize(context:BehaviorContext):Void {
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 

     	var targetEntity:Entity = cast Reflect.field(context.data,"targetEntity");
    	if (targetEntity==null)
    		return Failure;

        var targetHull = targetEntity.getComponent(PhysicsCollision);
        var entityHull = context.entity.getComponent(PhysicsCollision);

        if (!targetHull.proxy.aabb.overlap(entityHull.proxy.aabb))
            return Failure;

        return Success;

    }

}