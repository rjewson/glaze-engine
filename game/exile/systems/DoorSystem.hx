package exile.systems;

import exile.components.Door;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Display;
import glaze.engine.components.State;
import glaze.physics.components.PhysicsCollision;
import glaze.util.StateChangeProxy;

class DoorSystem extends System {
	
	var scp:StateChangeProxy;

    public function new() {
        super([Door,PhysicsCollision,State,Display]);
        this.hasUpdate = false;
        this.scp = new StateChangeProxy();
        this.scp.registerStateHandler("open",openDoor2);
        this.scp.registerStateHandler("closed",closeDoor2);
    }

    override public function entityAdded(entity:Entity) {
    	var state = entity.getComponent(State);
    	scp.registerState(state);
	}

	override public function entityRemoved(entity:Entity) {
		var state = entity.getComponent(State);
    	scp.unregisterState(state);
	}

	override public function update(timestamp:Float,delta:Float) {
	}

	public function openDoor2(state:State) {
    	var pc = state.owner.getComponent(PhysicsCollision);
	    pc.proxy.responseBias.x=0;
	    var display = state.owner.getComponent(Display);
	    display.update("dooropen.png");
	    display.displayObject.scale.setTo(1,2);
	}

	public function closeDoor2(state:State) {
    	var pc = state.owner.getComponent(PhysicsCollision);
	    pc.proxy.responseBias.x=1;
	   	var display = state.owner.getComponent(Display);
	    display.update("door.png");
	    display.displayObject.scale.setTo(1,1);
	}

}