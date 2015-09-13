package examples.systems;

import example.components.Player;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.particle.IParticleEngine;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class PlayerSystem extends System {

    public var particleEngine:IParticleEngine;

    public function new(particleEngine:IParticleEngine) {
        super([Player,PhysicsCollision]);
        this.particleEngine = particleEngine;
    }

    override public function entityAdded(entity:Entity) {
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {
    }

}