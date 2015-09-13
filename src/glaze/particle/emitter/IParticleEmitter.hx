
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.geom.Vector2;

interface IParticleEmitter 
{
    function update(time:Float, entity:Entity, engine:IParticleEngine):Void;
}
