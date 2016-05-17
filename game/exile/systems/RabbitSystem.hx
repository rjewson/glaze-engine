package exile.systems;

import exile.components.Rabbit;
import exile.components.Grenade;
import glaze.animation.components.SpriteAnimation;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.physics.components.PhysicsBody;
import glaze.util.Random;

class RabbitSystem extends System {

    public var particleEngine:IParticleEngine;
    public var scaredOfPosition:Position;

    public function new() {
        super([Position,Rabbit,PhysicsBody,SpriteAnimation]);
    }

    override public function entityAdded(entity:Entity) {        
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        // return;
        for (entity in view.entities) {
            var dist:Float = 1000*1000;
            var body = entity.getComponent(PhysicsBody).body;
            var dir = 0;
            var rabbit = entity.getComponent(Rabbit);
            rabbit.sleep-=delta;

            if (scaredOfPosition!=null) {
                dist = body.position.distSqrd(scaredOfPosition.coords);
                dir = (body.position.x - scaredOfPosition.coords.x)<0 ? -1:1;
            }
            if (dist<64*64) {
                if (Random.RandomBoolean(0.1)) {
                    body.addForce(new Vector2(dir*5000,-8000));
                    entity.getComponent(Position).direction.x = dir;
                    entity.getComponent(SpriteAnimation).animationController.play("jump");
                }                
            } else if (rabbit.sleep<0){
                if (Random.RandomBoolean(0.01)) {
                    rabbit.sleep+=2000;
                    var dir = Random.RandomSign(0.5);
                    entity.getComponent(Position).direction.x = dir;
                    body.addForce(new Vector2(dir*5000,-8000));
                    entity.getComponent(SpriteAnimation).animationController.play("jump");
                } else if (Random.RandomBoolean(0.005)) {
                    rabbit.sleep+=1500;
                    entity.getComponent(SpriteAnimation).animationController.play("listen");
                } else if (Random.RandomBoolean(0.005)) {
                    rabbit.sleep+=2000;
                    entity.getComponent(SpriteAnimation).animationController.play("eat");
                }
            }
            // if (Random.RandomBoolean(0.05)) {
            //     var chicken = entity.getComponent(Chicken);
            //     var body = entity.getComponent(PhysicsBody).body;
            //     var dir = Random.RandomSign(0.5);
            //     body.addForce(new Vector2(dir*10,-10));
            //     particleEngine.EmitParticle(body.position.x,body.position.y,  (dir*-10),-100,  0,5,  600,1,true,true,null,4,255,255,255,255);
            // }
        }
    }

}