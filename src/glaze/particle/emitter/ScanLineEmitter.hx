
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;

class ScanLineEmitter implements IParticleEmitter
{

    public var velocity:Float;    
    public var interval:Float;
    public var ttl:Int;
    public var jitter:Int;
    var lastTime:Float;

    public function new(interval:Float,velocity:Float,ttl:Int,jitter:Int) {
        this.velocity = velocity;
        this.interval = interval;
        this.ttl = ttl;
        this.jitter = jitter;
        this.lastTime = 0;
    }

    public function update(time:Float, entity:Entity, engine:IParticleEngine,spriteEngine:IParticleEngine):Void {
        if (time-lastTime<interval) 
            return;
        lastTime = time;
        var position = entity.getComponent(Position).coords;
        var extents = entity.getComponent(Extents).halfWidths;
        for (x in 0 ... 16) {
            engine.EmitParticle(position.x-16+(x*2),position.y-extents.y,0,velocity+glaze.util.Random.RandomInteger(-jitter,jitter),0,0,ttl,0.99,true,true,null,4,255,255,255,255);        
        }
    }

}