package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.eco.core.Entity;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.components.PhysicsStatic;


class PhysicsStaticSystem extends System {
    
    public var broadphase:IBroadphase;

    public function new(broadphase:IBroadphase) {
        super([Position,Extents,PhysicsCollision,PhysicsStatic]);
        this.broadphase = broadphase;
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        var extents = entity.getComponent(Extents);
        var position = entity.getComponent(Position);

        collision.proxy = new glaze.physics.collision.BFProxy(extents.halfWidths.x,extents.halfWidths.y,collision.filter);
        collision.proxy.isStatic = true;
        collision.proxy.aabb.position = entity.getComponent(Position).coords; //??

        broadphase.addProxy(collision.proxy);
    }
    
    override public function entityRemoved(entity:Entity) {
        broadphase.removeProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function update(timestamp:Float,delta:Float) {
    }
}