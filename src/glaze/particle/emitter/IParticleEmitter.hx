
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;

interface IParticleEmitter 
{
    function update(time:Float, entity:Entity, engine:IParticleEngine,spriteEngine:IParticleEngine):Void;
}
