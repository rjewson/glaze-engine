package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Viewable;
import glaze.particle.IParticleEngine;

class ParticleSystem extends System {

    public var particleEngine:IParticleEngine;

    public function new(particleEngine:IParticleEngine) {
        super([Position,ParticleEmitters,Active]);
        this.particleEngine = particleEngine;
    }

    override public function entityAdded(entity:Entity) {
        entity.getComponent(ParticleEmitters).particleEngine = this.particleEngine;
    }

    override public function entityRemoved(entity:Entity) {
        entity.getComponent(ParticleEmitters).particleEngine = null;
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            for (emitter in entity.getComponent(ParticleEmitters).emitters) {
                emitter.update(timestamp, entity, particleEngine);
            }
        }
        particleEngine.Update();
    }

}