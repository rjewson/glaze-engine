package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.CollisionCounter;
import glaze.engine.components.LifeCycle;
import glaze.engine.components.Moveable;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class CollisionCountSystem extends System {

    public function new() {
        super([CollisionCounter,PhysicsCollision,Active]);
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.push(callback);
    }

    override public function entityRemoved(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.remove(callback);
    }

    override public function update(timestamp:Float,delta:Float) {
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {

        var cc = a.entity.getComponent(CollisionCounter);
        var count = --cc.count;

        //This is the world
        if (b==null) {
            if (count<=0 && cc.onCount!=null)
                cc.onCount(a.entity);
        } else {
            //Do nothing with sensor
            if (b.isSensor)
                return;  

            //Hit Dynamic item? trigger directly
            if (b.entity.getComponent(Moveable)!=null && cc.onCount!=null ) {
                cc.onCount(a.entity);
            }           
        }

    }

}