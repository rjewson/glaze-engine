package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Held;
import glaze.engine.components.Holdable;
import glaze.engine.components.Holder;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Viewable;
import glaze.engine.components.Water;
import glaze.particle.IParticleEngine;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;
import glaze.geom.Vector2;
import glaze.physics.components.PhysicsStatic;
import glaze.util.Random.RandomFloat;

class HolderSystem extends System {

    public function new() {
        super([PhysicsCollision,Extents,Holder]);
    }

    override public function entityAdded(entity:Entity) {
        var physicsCollision = entity.getComponent(PhysicsCollision);
        physicsCollision.proxy.contactCallbacks.push(callback);//setCallback(callback);
        physicsCollision.proxy.filter.maskBits = physicsCollision.proxy.filter.maskBits | 0x2;
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {   
        var holder = a.entity.getComponent(Holder);
        if (holder.hold==true) {
            var holdable = b.entity.getComponent(Holdable);
            if (holder.heldItem==null && b.entity.getComponent(Held)==null) {
                var held = new Held();
                held.holder = a.entity;
                b.entity.addComponent(held);
                holder.heldItem = b.entity;
            }
        }
    }

}