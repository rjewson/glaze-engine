package exile.systems;

import exile.components.Projectile;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Destroy;
import glaze.engine.components.Position;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class ProjectileSystem extends System {

    var broadphase:IBroadphase;
    var bfAreaQuery:glaze.util.BroadphaseAreaQuery;


    public function new(broadphase:IBroadphase) {
        super([Projectile,PhysicsCollision]);
        this.broadphase = broadphase;
        bfAreaQuery = new glaze.util.BroadphaseAreaQuery(broadphase);
    }

    override public function entityAdded(entity:Entity) {
        
        var projectile = entity.getComponent(Projectile);
        projectile.age = projectile.type.ttl;
        projectile.bounce = projectile.type.bounce;

        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.push(callback);

    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var projectile = entity.getComponent(Projectile);
            projectile.age-=delta;
            if ((projectile.age<0 || projectile.bounce<=0) && entity.getComponent(Destroy)==null) {
                entity.addComponent(new Destroy(2)); 
                entity.getComponent(glaze.engine.components.ParticleEmitters).emitters.push(new glaze.particle.emitter.Explosion(10,50));
                bfAreaQuery.query(entity.getComponent(Position).coords,64,entity,true);
                var item = bfAreaQuery.entityCollection.entities.head;
                while (item!=null) {
                    var body = item.entity.getComponent(glaze.physics.components.PhysicsBody);
                    if (body!=null) {
                        var delta = body.body.position.clone();
                        delta.minusEquals(entity.getComponent(Position).coords);
                        delta.normalize();
                        delta.multEquals(200);
                        body.body.addForce(delta);
                    }
                    item = item.next;
                }
                trace(bfAreaQuery.entityCollection);
            }
        }
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {
        if (b!=null && b.isSensor)
            return;
        a.entity.getComponent(Projectile).bounce--;
    }


}