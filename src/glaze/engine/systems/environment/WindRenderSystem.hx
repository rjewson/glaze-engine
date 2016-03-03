package glaze.engine.systems.environment;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.EnvironmentForce;
import glaze.engine.components.Extents;
import glaze.engine.components.Viewable;
import glaze.engine.components.Wind;
import glaze.particle.IParticleEngine;
import glaze.physics.components.PhysicsCollision;
import glaze.util.Random.RandomFloat;

class WindRenderSystem extends System {

    public var particleEngine:IParticleEngine;

    public function new(particleEngine:IParticleEngine) {
        super([Extents,EnvironmentForce,Wind,Viewable,PhysicsCollision,Active]);
        this.particleEngine = particleEngine;
    }

    override public function entityAdded(entity:Entity) {
        var extents = entity.getComponent(Extents);
        var units = ((extents.halfWidths.x*extents.halfWidths.y) * 4) / (glaze.EngineConstants.TILE_SIZE*glaze.EngineConstants.TILE_SIZE);
        var wind = entity.getComponent(Wind);
        wind.incPerFrame = wind.particlePerUnitPerFrame*units;
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var wind = entity.getComponent(Wind);
            wind.particleCount += wind.incPerFrame;
            var proxy = entity.getComponent(PhysicsCollision).proxy;
            var envForce = entity.getComponent(EnvironmentForce);
            while (wind.particleCount>1) {
                particleEngine.EmitParticle(
                    RandomFloat(proxy.aabb.l,proxy.aabb.r),RandomFloat(proxy.aabb.t,proxy.aabb.b),
                    (envForce.direction.x*envForce.power)/5,
                    (envForce.direction.y*envForce.power)/5,
                    0,1,glaze.util.Random.RandomInteger(300,600),1,true,true,null,4,255,255,255,255);

                //particleEngine.EmitParticle(RandomFloat(proxy.aabb.l,proxy.aabb.r),RandomFloat(proxy.aabb.t,proxy.aabb.b),RandomFloat(-20,20),RandomFloat(-20,20),0,1,1000,1,true,true,null,4,255,255,255,255);
                wind.particleCount--;
            }
        }
    }

}
