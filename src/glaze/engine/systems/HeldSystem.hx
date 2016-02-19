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
import glaze.engine.components.Storeable;
import glaze.engine.components.Viewable;
import glaze.engine.components.Water;
import glaze.particle.IParticleEngine;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.geom.Vector2;
import glaze.physics.components.PhysicsConstraints;
import glaze.physics.constraint.Spring;
import glaze.util.Random.RandomFloat;

class HeldSystem extends System {

    public function new() {
        super([Holdable,Held,PhysicsBody,Active]);
    }

    override public function entityAdded(entity:Entity) {
        var body = entity.getComponent(PhysicsBody).body;
        body.velocity.setTo(0,0);
        body.skip = true;

        var holder = entity.getComponent(Held).holder;
        var holderPos = holder.getComponent(glaze.engine.components.Position).coords;

        entity.getComponent(Position).coords.copy(holderPos);
        entity.getComponent(PhysicsBody).body.position.copy(holderPos);

        if (entity.getComponent(Storeable)==null) {
            var holderBody = holder.parent.getComponent(PhysicsBody).body;
            if (holderBody!=null) {
                holderBody.setMass(holderBody.mass+body.mass);
            }
        }
    }

    override public function entityRemoved(entity:Entity) {
        var holder = entity.getComponent(Held).holder;
        holder.getComponent(Holder).drop();
        var body = entity.getComponent(PhysicsBody).body;
        body.skip = false;

        if (entity.getComponent(Storeable)==null) {
            var holderBody = holder.parent.getComponent(PhysicsBody).body;
            if (holderBody!=null) {
                holderBody.setMass(holderBody.mass-body.mass);
            }
        }

    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var holder = entity.getComponent(Held).holder;
            var holderPos = holder.getComponent(glaze.engine.components.Position).coords;

            entity.getComponent(Position).coords.copy(holderPos);
            // entity.getComponent(PhysicsBody).body.position.copy(holderPos);
            entity.getComponent(PhysicsBody).body.setPosition(holderPos.x,holderPos.y-15); //position.copy(holderPos);
        }

    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {        
    }

}