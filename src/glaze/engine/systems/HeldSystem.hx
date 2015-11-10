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
import glaze.util.Random.RandomFloat;

class HeldSystem extends System {

    public function new() {
        super([Holdable,Held,PhysicsBody]);
    }

    override public function entityAdded(entity:Entity) {
        var body = entity.getComponent(PhysicsBody).body;
        body.velocity.setTo(0,0);
        body.skip = true;
    }

    override public function entityRemoved(entity:Entity) {
        var body = entity.getComponent(PhysicsBody).body;
        body.skip = false;
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var bodyPosition = entity.getComponent(Position);
            var holder = entity.getComponent(Held).holder;
            var holderPos = holder.getComponent(glaze.engine.components.Position).coords;

            entity.getComponent(Position).coords.copy(holderPos);
            entity.getComponent(PhysicsBody).body.position.copy(holderPos);
        }

    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {        
    }

}