package exile.systems;

import exile.components.Chicken;
import exile.components.Grenade;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.physics.components.PhysicsBody;
import glaze.util.Random;

class ChickenSystem extends System {

    public var particleEngine:IParticleEngine;
    public var scaredOfPosition:Position;

    public function new(particleEngine:IParticleEngine) {
        super([Position,Chicken,PhysicsBody]);
        this.particleEngine = particleEngine;
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
            if (scaredOfPosition!=null) {
                dist = body.position.distSqrd(scaredOfPosition.coords);
                dir = (body.position.x - scaredOfPosition.coords.x)<0 ? -1:1;
            }
            if (dist<64*64) {
                if (Random.RandomBoolean(0.1)) {
                    body.addForce(new Vector2(dir*50000,-50000));
                    particleEngine.EmitParticle(body.position.x,body.position.y,  (dir*-10),-100,  0,5,  800,1,false,true,null,4,255,255,255,255);
                }                
            } else {
                if (Random.RandomBoolean(0.02)) {
                    var dir = Random.RandomSign(0.5);
                    entity.getComponent(Position).direction.x = -dir;
                    body.addForce(new Vector2(dir*50000,-50000));
                    particleEngine.EmitParticle(body.position.x,body.position.y,  (dir*-20),-100,  0,5,  800,1,false,true,null,4,255,255,255,255);
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