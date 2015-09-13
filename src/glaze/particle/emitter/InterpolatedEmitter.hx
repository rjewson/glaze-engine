
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.util.Random.RandomFloat;

class InterpolatedEmitter implements IParticleEmitter
{

    public var rate:Int;
    public var speed:Float;
    public var prevPosition:Vector2;
    var temp:Vector2 = new Vector2();

    public function new(rate:Int,speed:Float) {
        this.rate = rate;
        this.speed = speed;
    }

    public function update(time:Float, entity:Entity, engine:IParticleEngine):Void {
        var position = entity.getComponent(Position).coords;
        if (prevPosition==null) {
            prevPosition = position.clone();
        }
        temp.copy(prevPosition);
        temp.minusEquals(position);
        var len:Int = Std.int(temp.length()/9);
        if (len==0) len = 1;
        for (i in 0 ... len) {
            temp.interpolate(prevPosition,position,i/len);
            var angle = RandomFloat(0,2*Math.PI);
            var vx = Math.cos(angle) * speed*RandomFloat(0,2);
            var vy = Math.sin(angle) * speed*RandomFloat(0,2);
            engine.EmitParticle(temp.x,temp.y,vx,vy,0,0,Std.int(1200*RandomFloat(0.2,1.2)),0.99,true,true,null,4,255,255,255,255);
        }
        prevPosition.copy(position);
    }

}