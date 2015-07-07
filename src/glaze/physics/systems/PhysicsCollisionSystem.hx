package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.eco.core.Entity;
import glaze.physics.components.PhysicsCollision;


class PhysicsCollisionSystem extends System {
    
    public var broadphase:IBroadphase;

    public function new(broadphase:IBroadphase) {
        super([PhysicsCollision]);
        this.broadphase = broadphase;
    }

    override public function entityAdded(entity:Entity) {
        var proxy = entity.getComponent(PhysicsCollision).proxy;
        proxy.entity = entity;
        broadphase.addProxy(proxy);
    }
    
    override public function entityRemoved(entity:Entity) {
        broadphase.removeProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function update(timestamp:Float,delta:Float) {
        broadphase.collide();
    }
}