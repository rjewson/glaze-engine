package glaze.engine.systems;

import glaze.ai.behaviortree.BehaviorContext;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.CollidableSwitch;
import glaze.engine.components.Destroy;
import glaze.engine.components.Script;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;
import glaze.util.MessageBus;

class CollidableSwitchSystem extends System {

    var bus:MessageBus;
    var ts:Float = 0;

    public function new(bus:MessageBus) {
        super([CollidableSwitch,PhysicsCollision]);
        this.bus = bus;
        // hasUpdate = false;
    }

    override public function entityAdded(entity:Entity) {
        var collidableSwitch =  entity.getComponent(CollidableSwitch);
        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.push(onCollision);
    }

    override public function entityRemoved(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.remove(onCollision);
    }

    override public function update(timestamp:Float,delta:Float) {
        ts = timestamp;
    }

    function onCollision(a:BFProxy,b:BFProxy,c:Contact) {
        var collidableSwitch = a.entity.getComponent(CollidableSwitch);
        if (collidableSwitch.trigger(ts))
            bus.triggerAll(collidableSwitch.triggerChannels,null);
    }

}