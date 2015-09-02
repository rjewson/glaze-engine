
package glaze.particle.emitter;

import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.util.Random.RandomFloat;

class FieldEmitter implements IParticleEmitter
{

    public function new() {
    }

    public function update(time:Float, position:Vector2, engine:IParticleEngine):Void {
        for (y in 5...25 ) {  
            for (x in 15...20) {
               engine.EmitParticle((x*32)-16,(y*32)-16,0,0,0,0,17,1,false,true,null,32,128,255,255,255);             
            }
        }

    }

}