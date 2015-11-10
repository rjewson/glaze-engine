package exile.systems;

import exile.components.Door;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Display;
import glaze.engine.components.State;
import glaze.physics.components.PhysicsCollision;

class DoorSystem extends System {
	
    public function new() {
        super([Door,PhysicsCollision,State,Display]);
        this.hasUpdate = false;
    }

    override public function entityAdded(entity:Entity) {
    	var state = entity.getComponent(State);
    	state.onChanged.add(setDoorState);
    	setDoorState(state);
	}

	override public function entityRemoved(entity:Entity) {
	}

	override public function update(timestamp:Float,delta:Float) {
	}

	public function setDoorState(state:State) {
		var door = state.owner.getComponent(Door);
		if (state.getState()=="open") {
			openDoor(state.owner);
		} else {
			closeDoor(state.owner);
		}
	}

	public function openDoor(entity:Entity) {
    	var pc = entity.getComponent(PhysicsCollision);
	    pc.proxy.responseBias.x=0;
	    var display = entity.getComponent(Display);
	    display.update("dooropen.png");
	    display.displayObject.scale.setTo(1,2);

	}

	public function closeDoor(entity:Entity) {
    	var pc = entity.getComponent(PhysicsCollision);
	    pc.proxy.responseBias.x=1;
	   	var display = entity.getComponent(Display);
	    display.update("door.png");
	    display.displayObject.scale.setTo(1,1);
	}

}