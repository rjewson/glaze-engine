package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.eco.core.Entity;
import glaze.physics.components.PhysicsCollision;


class PhysicsCollisionSystem extends System {
    
    public var broadphase:IBroadphase;

    public function new(broadphase:IBroadphase) {
        super([PhysicsCollision,PhysicsBody,Moveable]);
        this.broadphase = broadphase;
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        var body = entity.getComponent(PhysicsBody);
        //All this really does is add the body to the proxy and run the physics
        collision.proxy.setBody(body.body);
    }

    override public function update(timestamp:Float,delta:Float) {
        broadphase.collide();
    }
}