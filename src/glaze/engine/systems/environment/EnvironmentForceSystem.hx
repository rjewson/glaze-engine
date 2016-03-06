package glaze.engine.systems.environment;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.EnvironmentForce;
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
import motion.Actuate;

class EnvironmentForceSystem extends System {

    public var particleEngine:IParticleEngine;

    public var temp:Vector2 = new Vector2();

    public function new() {
        super([PhysicsCollision,Extents,EnvironmentForce,Active]);
    }

    override public function entityAdded(entity:Entity) {
        entity.getComponent(PhysicsCollision).proxy.contactCallbacks.push(callback);
        var force = entity.getComponent(EnvironmentForce);
        setActiveForce(force,0);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var force = entity.getComponent(EnvironmentForce);
            if (force.ttl>0) {
                force.ttl-=delta;
                if (force.ttl<=0) {
                    Actuate.tween (force, 1, { power: 0 }).onComplete (onFinished,[force]);
                }    
            }
        }
    }

    public function onFinished(force:EnvironmentForce) {
        force.currentIndex++;
        if (force.currentIndex>=force.data.length)
            force.currentIndex = 0;
        setActiveForce(force,force.currentIndex);
    }

    public function setActiveForce(envForce:EnvironmentForce,index:Int) {
        envForce.currentIndex = index;
        var item = envForce.data[index];
        envForce.direction.copy(item.direction);
        envForce.power = item.maxForce;    
        envForce.ttl = item.minDuration==0 ? -1 : glaze.util.Random.RandomFloat(item.minDuration*1000,item.maxDuration*1000);    
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {        

        var area = a.aabb.overlapArea(b.aabb);
        // b.body.addForce(new Vector2(0,-area*40));

        // trace(percent);
        var force = a.entity.getComponent(EnvironmentForce);
        //TODO SCALE FORCE BY ACTUAL AREA!!!!!!
        temp.copy(force.direction);
        // temp.multEquals(force.power/40);
        temp.multEquals(40*area);
        b.body.addForce(temp);
    }

    // public function callback(a:BFProxy,b:BFProxy,contact:Contact) {        
    //     var areaOverlap = b.aabb.overlapArea(a.aabb);
    //     var percent = areaOverlap/b.aabb.area();
    //     // trace(percent);
    //     var force = a.entity.getComponent(EnvironmentForce);
    //     //TODO SCALE FORCE BY ACTUAL AREA!!!!!!
    //     temp.copy(force.direction);
    //     temp.multEquals(force.power/1000);
    //     temp.multEquals(percent);
    //     b.body.addProportionalForce(temp);
    // }

}