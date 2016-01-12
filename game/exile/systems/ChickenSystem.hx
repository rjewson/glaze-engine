package exile.systems;

import exile.components.Chicken;
import exile.components.Grenade;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.physics.components.PhysicsBody;
import glaze.util.Random;

class ChickenSystem extends System {

    public var particleEngine:IParticleEngine;

    public function new(particleEngine:IParticleEngine) {
        super([Chicken,PhysicsBody]);
        this.particleEngine = particleEngine;
    }

    override public function entityAdded(entity:Entity) {        
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            if (Random.RandomBoolean(0.05)) {
                var chicken = entity.getComponent(Chicken);
                var body = entity.getComponent(PhysicsBody).body;
                var dir = Random.RandomSign(0.5);
                body.addForce(new Vector2(dir,-1));
                particleEngine.EmitParticle(body.position.x,body.position.y,  (dir*-10),-100,  0,5,  600,1,true,true,null,4,255,255,255,255);
            }
        }
    }

}