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
        // for (proxy in entity.getComponent(PhysicsCollision).proxies)
        //     broadphase.addProxy(proxy);
        broadphase.addProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function entityRemoved(entity:Entity) {
        // for (proxy in entity.getComponent(PhysicsCollision).proxies)
        //     broadphase.removeProxy(proxy);
        broadphase.removeProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function update(timestamp:Float,delta:Float) {
        broadphase.collide();
    }
}