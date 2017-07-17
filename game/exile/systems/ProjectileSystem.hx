package exile.systems;

import exile.components.Projectile;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Destroy;
import glaze.engine.components.Health;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class ProjectileSystem extends System {

    public function new() {
        super([Projectile,PhysicsCollision,Health]);
    }

    override public function entityAdded(entity:Entity) {
        
        var projectile = entity.getComponent(Projectile);
        projectile.age = projectile.type.ttl;
        projectile.bounce = projectile.type.bounce;

        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.push(callback);
        var x = new V2();
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            if (entity.getComponent(Destroy)!=null)
                continue;
            var projectile = entity.getComponent(Projectile);
            projectile.age-=delta;
            var health = entity.getComponent(Health);
            if ((projectile.age<0 || projectile.bounce<=0 || health.currentHealth<0) && entity.getComponent(Destroy)==null) {
                entity.addComponent(new Destroy(1)); 
                entity.getComponent(glaze.engine.components.ParticleEmitters).emitters.push(new glaze.particle.emitter.Explosion(10,50));
                glaze.util.CombatUtils.explode(entity.getComponent(Position).coords,64,10000,entity);
            }
        }
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {
        if (b!=null) {
            if (b.isSensor)
                return;
            if (b.entity.getComponent(Moveable)!=null) {
                a.entity.getComponent(Projectile).bounce = 0;
                return;
            }
        }
        a.entity.getComponent(Projectile).bounce--;
    }


}