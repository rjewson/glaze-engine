package glaze.engine.components;

import glaze.geom.Vector2;
import glaze.eco.core.IComponent;
import glaze.particle.emitter.IParticleEmitter;
import glaze.particle.IParticleEngine;

class ParticleEmitters implements IComponent {

    public var emitters:Array<IParticleEmitter>;
    //public var particleEngine:IParticleEngine;

    public function new(emitters) {
        this.emitters = emitters;
    }

}