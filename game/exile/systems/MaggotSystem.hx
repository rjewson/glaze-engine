package exile.systems;

import exile.components.Chicken;
import exile.components.Grenade;
import exile.components.Maggot;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.util.Random;
import glaze.animation.components.SpriteAnimation;

class MaggotSystem extends System {

    var broadphase:IBroadphase;
    var bfAreaQuery:glaze.util.BroadphaseAreaQuery;
    var particleEngine:IParticleEngine;
    
    public var scaredOfPosition:Position;

    public function new(broadphase:IBroadphase,particleEngine:IParticleEngine) {
        super([Maggot,PhysicsBody,SpriteAnimation]);
        this.broadphase = broadphase;
        this.particleEngine = particleEngine;
        bfAreaQuery = new glaze.util.BroadphaseAreaQuery(broadphase);
    }

    override public function entityAdded(entity:Entity) {        
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var maggot = entity.getComponent(Maggot);
            maggot.sleep-=delta;
            if (Random.RandomBoolean(0.02)) {
                entity.getComponent(SpriteAnimation).animationController.play("jump");
                var body = entity.getComponent(PhysicsBody).body;
                var dir = Random.RandomSign(0.5);
                body.addForce(new Vector2(dir*5,-10)); 
            } else if (Random.RandomBoolean(0.01)) {
                entity.getComponent(SpriteAnimation).animationController.play("blink");
            } else if (maggot.sleep<0&&Random.RandomBoolean(0.02)) {
                maggot.sleep = 2000;
                var body = entity.getComponent(PhysicsBody).body;
                bfAreaQuery.query(body.position,64,entity,true);
                if (bfAreaQuery.entityCollection.entities.head!=null) {
                    glaze.util.Ballistics.calcProjectileVelocity(body,bfAreaQuery.entityCollection.entities.head.entity.getComponent(Position).coords,300);
                }
            }
        }
    }

}