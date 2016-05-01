package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Viewable;
import glaze.engine.components.Water;
import glaze.particle.IParticleEngine;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;
import glaze.geom.Vector2;
import glaze.util.Random.RandomFloat;
 
class WaterSystem extends System {

    public var particleEngine:IParticleEngine;

    public function new(particleEngine:IParticleEngine) {
        super([PhysicsCollision,Extents,Water]);
        this.particleEngine = particleEngine;
    }

    override public function entityAdded(entity:Entity) {
        var cb2 = new glaze.signals.Signal3<BFProxy,BFProxy,Contact>();
        cb2.add(callback);
        entity.getComponent(PhysicsCollision).proxy.contactCallbacks.push(cb2.dispatch);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {        
        var area = a.aabb.overlapArea(b.aabb);
        b.body.damping = 0.90;
        b.body.addForce(new Vector2(0,-area*5));
        // trace(-area*0.05,b.body.mass);
        if (!b.body.inWaterPrev) {
                particleEngine.EmitParticle(RandomFloat(b.aabb.l,b.aabb.r),a.aabb.t,RandomFloat(-20,20),RandomFloat(-5,-15),0,1,500,1,true,true,null,4,255,255,255,255);
                particleEngine.EmitParticle(RandomFloat(b.aabb.l,b.aabb.r),a.aabb.t,RandomFloat(-20,20),RandomFloat(-5,-15),0,1,500,1,true,true,null,4,255,255,255,255);
                particleEngine.EmitParticle(RandomFloat(b.aabb.l,b.aabb.r),a.aabb.t,RandomFloat(-20,20),RandomFloat(-5,-15),0,1,500,1,true,true,null,4,255,255,255,255);

        } else if (b.aabb.t<a.aabb.t) {
            if (glaze.util.Random.RandomBoolean(0.1) && a.entity.getComponent(Viewable)!=null) {
                particleEngine.EmitParticle(RandomFloat(b.aabb.l,b.aabb.r),a.aabb.t,RandomFloat(-20,20),RandomFloat(-5,-15),0,1,500,1,true,true,null,4,255,255,255,255);
            }
        }
        b.body.inWater = true;

    }

}