
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.util.Random;

class FireballEmitter implements IParticleEmitter
{

    public var rate:Int;
    public var speed:Float;

    public function new(rate:Int,speed:Float) {
        this.rate = rate;
        this.speed = speed;
        this.speed = 400;
    }

    public function update(time:Float, entity:Entity, engine:IParticleEngine):Void {
        var position = entity.getComponent(Position).coords;
        var body = entity.getComponent(glaze.physics.components.PhysicsBody).body;
        for (i in 0 ... 5) {
            var angle = Random.RandomFloat(0,2*Math.PI);
            var vx = body.velocity.x + (Math.cos(angle) * speed*Random.RandomFloat(0,2));
            var vy = body.velocity.y + (Math.sin(angle) * speed*Random.RandomFloat(0,2));
            // var g = 0;//i%2==0 ? 255 : 0;
            // var r = Random.RandomInteger(128,255);
            // engine.EmitParticle(position.x,position.y,vx,vy,0,0,150,0.50,true,true,null,4,255, r,g,0);
            engine.EmitParticle(position.x,position.y,vx,vy,0,0,100,0.50,true,true,null,4,255, 229,252,114);

            // var c = Random.RandomInteger(128,255);
            // if (i%2==0) {
            //     engine.EmitParticle(position.x,position.y,vx,vy,0,0,60,0.30,true,true,null,4,255, c,0,0);
            // } else {
            //     engine.EmitParticle(position.x,position.y,vx,vy,0,0,60,0.30,true,true,null,4,255, c,c,0);
            // }
        }
    }

}