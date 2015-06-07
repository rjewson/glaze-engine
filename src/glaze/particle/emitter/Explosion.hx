
package wgr.particle.emitter;

import physics.geometry.Vector2D;
import wgr.particle.IParticleEngine;

class Explosion implements IParticleEmitter
{

    public var mass:Int;
    public var power:Float;

    public function new(mass:Int,power:Float) {
        this.mass = mass;
        this.power = power;
    }

    public function update(time:Float, position:Vector2D, engine:IParticleEngine):Void {
        for (i in 0...mass) {
            var angle = utils.Random.RandomFloat(0,Math.PI*2);
            var p = utils.Random.RandomFloat(0,power*2);
            var vx = Math.cos(angle) * p;
            var vy = Math.sin(angle) * p;
            engine.EmitParticle(position.x,position.y,vx,vy,0,0.5,utils.Random.RandomInteger(300,1000),0.9,true,true,null,4,255,255,0,0);
        }
    }


}