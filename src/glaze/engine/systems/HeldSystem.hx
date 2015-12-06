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
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.geom.Vector2;
import glaze.physics.components.PhysicsConstraints;
import glaze.physics.constraint.Spring;
import glaze.util.Random.RandomFloat;

class HeldSystem extends System {

    public function new() {
        super([Holdable,Held,PhysicsBody]);
    }

    override public function entityAdded(entity:Entity) {
        var body = entity.getComponent(PhysicsBody).body;
        body.velocity.setTo(0,0);
        body.skip = true;

        var held = entity.getComponent(Held);
        var holderBody = held.holder.parent.getComponent(PhysicsBody).body;
    }

    override public function entityRemoved(entity:Entity) {
        // js.Lib.debug();
        entity.getComponent(Held).holder.getComponent(Holder).drop();
        var body = entity.getComponent(PhysicsBody).body;
        body.skip = false;
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            // for (i in 0...5) {
            //     entity.getComponent(Held).spring.resolve();                
            // }
            var holder = entity.getComponent(Held).holder;
            var holderPos = holder.getComponent(glaze.engine.components.Position).coords;

            entity.getComponent(Position).coords.copy(holderPos);
            entity.getComponent(PhysicsBody).body.position.copy(holderPos);
        }

    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {        
    }

}