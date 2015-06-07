
package glaze.particle.emitter;

import glaze.geom.Vector2;

interface IParticleEmitter 
{
    function update(time:Float, position:Vector2, engine:IParticleEngine):Void;
}
