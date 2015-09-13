package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.eco.core.Entity;
import glaze.physics.components.PhysicsCollision;


class PhysicsCollisionSystem extends System {
    
    public var broadphase:IBroadphase;

    public function new(broadphase:IBroadphase) {
        super([Extents,PhysicsCollision,PhysicsBody]);
        this.broadphase = broadphase;
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        var extents = entity.getComponent(Extents);
        // var position = entity.getComponent(Position);
        var body = entity.getComponent(PhysicsBody);

        collision.proxy = new glaze.physics.collision.BFProxy(extents.halfWidths.x,extents.halfWidths.y,collision.filter);
        collision.proxy.setBody(body.body);
        collision.proxy.entity = entity;
        collision.proxy.isSensor = collision.isSensor;
        collision.setCallback(collision.contactCallback);
        
        broadphase.addProxy(collision.proxy);
    }
    
    override public function entityRemoved(entity:Entity) {
        // js.Lib.debug();
        broadphase.removeProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function update(timestamp:Float,delta:Float) {
        broadphase.collide();
    }
}