package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.eco.core.Entity;
import glaze.physics.components.PhysicsCollision;


class PhysicsStaticSystem extends System {
    
    public var broadphase:IBroadphase;

    public function new(broadphase:IBroadphase) {
        super([Position,Extents,PhysicsCollision,Fixed]);
        this.broadphase = broadphase;
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        var extents = entity.getComponent(Extents);
        var position = entity.getComponent(Position);

        position.updatePosition = setPosition;

        collision.proxy.aabb.extents.copy(extents.halfWidths);
        collision.proxy.entity = entity;
        collision.proxy.isStatic = true;
        collision.proxy.aabb.position = entity.getComponent(Position).coords; //Because its not linked to a body

        broadphase.addProxy(collision.proxy);
    }
    
    override public function entityRemoved(entity:Entity) {
        broadphase.removeProxy(entity.getComponent(PhysicsCollision).proxy);
    }

    override public function update(timestamp:Float,delta:Float) {
    }

    public function setPosition(entity:Entity,position:Vector2) {
        var bfp = entity.getComponent(PhysicsCollision).proxy;
        broadphase.removeProxy(bfp);
        bfp.aabb.position = entity.getComponent(Position).coords;
        broadphase.addProxy(bfp);
    }
}