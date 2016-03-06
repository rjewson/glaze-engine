package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.eco.core.Entity;
import glaze.physics.components.PhysicsCollision;


class PhysicsMoveableSystem extends System {
    
    public var broadphase:IBroadphase;

    public function new(broadphase:IBroadphase) {
        super([Position,Extents,PhysicsCollision,Moveable]);
        this.broadphase = broadphase;
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        var extents = entity.getComponent(Extents);

        collision.proxy.aabb.extents.copy(extents.halfWidths);
        collision.proxy.isStatic = false;
        collision.proxy.entity = entity;
        collision.proxy.aabb.position = entity.getComponent(Position).coords; //Because its not linked to a body BUT it could cause an issue?

        broadphase.addProxy(collision.proxy);
    }
    
    override public function entityRemoved(entity:Entity) {
        broadphase.removeProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function update(timestamp:Float,delta:Float) {
    }
}