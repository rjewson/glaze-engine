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

class HoldableSystem extends System {

    public function new() {
        super([PhysicsCollision,Extents,Holdable]);
    }

    override public function entityAdded(entity:Entity) {
        var physicsCollision = entity.getComponent(PhysicsCollision);
        physicsCollision.filter.categoryBits = 0x2;    
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

}