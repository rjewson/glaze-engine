
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;

class RandomSpray implements IParticleEmitter
{

    public var rate:Int;
    public var speed:Float;
    var lastTime:Float;

    public function new(rate:Int,speed:Float) {
        this.rate = rate;
        this.speed = speed;
        this.lastTime = 0;
    }

    public function update(time:Float, entity:Entity, engine:IParticleEngine):Void {
        if (time-lastTime<rate) 
            return;
        lastTime = time;
        var position = entity.getComponent(Position).coords;
        var angle = glaze.util.Random.RandomFloat(0,2*Math.PI);
        var vx = Math.cos(angle) * speed;
        var vy = Math.sin(angle) * speed;
        engine.EmitParticle(position.x,position.y,vx,vy,0,0,800,0.99,true,true,null,4,255,255,255,255);
    }

}