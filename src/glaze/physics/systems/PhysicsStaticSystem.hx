package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.physics.collision.BFProxy;
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
        var physics = entity.getComponent(PhysicsStatic);

        // collision.proxy = new BFProxy(extents.halfWidths.x,extents.halfWidths.y,collision.filter);
        collision.proxy.aabb.extents.copy(extents.halfWidths);
        collision.proxy.entity = entity;


        // collision.proxy.isStatic = physics.isStatic;
        // collision.proxy.isSensor = collision.isSensor;
        collision.proxy.aabb.position = entity.getComponent(Position).coords; //Because its not linked to a body
        // collision.proxy.entity = entity;
        // collision.setCallback(collision.contactCallback);


        broadphase.addProxy(collision.proxy);
    }
    
    override public function entityRemoved(entity:Entity) {
        broadphase.removeProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function update(timestamp:Float,delta:Float) {
    }
}