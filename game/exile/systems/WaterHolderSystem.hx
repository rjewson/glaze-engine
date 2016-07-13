package exile.systems;

import exile.components.Teleporter;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Display;
import glaze.engine.components.State;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class WaterHolderSystem extends System {
	
    public function new() {
        super([PhysicsCollision,Teleporter,State]);
        this.hasUpdate = false;
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.push(onCollision);

        var state = entity.getComponent(State);
    	state.onChanged.add(setTeleporterState);
    	setTeleporterState(state);
	}

	override public function entityRemoved(entity:Entity) {
	}

	override public function update(timestamp:Float,delta:Float) {
	}


    function onCollision(a:BFProxy,b:BFProxy,c:Contact) {
    	if (glaze.util.Random.RandomBoolean(0.1)) {
    		b.body.position.copy(a.entity.getComponent(Teleporter).teleportPosition);
    	}
    }

}