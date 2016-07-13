package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
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
import glaze.util.Random.RandomFloat;

class HolderSystem extends System {

    var holderFilterCategory:Int;

    public function new(holderFilterCategory:Int) {
        super([PhysicsCollision,Extents,Holder,Active]);
        this.holderFilterCategory = holderFilterCategory;
    }

    override public function entityAdded(entity:Entity) {
        var physicsCollision = entity.getComponent(PhysicsCollision);
        physicsCollision.proxy.contactCallbacks.push(callback);//setCallback(callback);
        physicsCollision.proxy.filter.maskBits |= holderFilterCategory;
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {   
        var holder = a.entity.getComponent(Holder);
        if (holder.activate==true) {
            holder.hold(b.entity,a.entity);
        }
    }

}