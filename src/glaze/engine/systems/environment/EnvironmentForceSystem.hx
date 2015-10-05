package glaze.engine.systems.environment;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.EnvironmentForce;
import glaze.engine.components.Extents;
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

class EnvironmentForceSystem extends System {

    public var particleEngine:IParticleEngine;

    public function new() {
        super([PhysicsCollision,PhysicsStatic,Extents,EnvironmentForce]);
    }

    override public function entityAdded(entity:Entity) {
        entity.getComponent(PhysicsCollision).proxy.contactCallbacks.push(callback);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {        
        var area = a.aabb.overlapArea(b.aabb);
        b.body.addForce(new Vector2(0,-area/80));
    }

}