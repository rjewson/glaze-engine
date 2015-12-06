
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.util.Random.Random;

class Explosion implements IParticleEmitter
{

    public var mass:Int;
    public var power:Float;

    public function new(mass:Int,power:Float) {
        this.mass = mass;
        this.power = power;
    }

    public function update(time:Float, entity:Entity, engine:IParticleEngine):Void {
        var position = entity.getComponent(Position).coords;
        for (i in 0...mass) {
            var angle = Random.RandomFloat(0,Math.PI*2);
            var p = Random.RandomFloat(0,power*2);
            var vx = Math.cos(angle) * p;
            var vy = Math.sin(angle) * p;
            engine.EmitParticle(position.x,position.y,vx,vy,0,1,Random.RandomInteger(50,200),0.99,false,true,null,4,255,255,0,0);
        }
    }


}