package exile.systems;

import exile.components.Grenade;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Destroy;
import glaze.engine.components.Health;
import glaze.engine.components.Position;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class GrenadeSystem extends System {

    var broadphase:IBroadphase;
    var bfAreaQuery:glaze.util.BroadphaseAreaQuery;

    public function new(broadphase:IBroadphase) {
        super([Grenade,PhysicsCollision,Health]);
        this.broadphase = broadphase;
        bfAreaQuery = new glaze.util.BroadphaseAreaQuery(broadphase);
    }

    override public function entityAdded(entity:Entity) {        
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var health = entity.getComponent(Health);
            if (health.isDead()) {
                entity.addComponent(new glaze.engine.components.ParticleEmitters([new glaze.particle.emitter.Explosion2(10,100)]));
                entity.addComponent(new Destroy(2)); 
            }
        }
    }

}