package glaze.ai.fsm;

import glaze.ai.fsm.IState;
import glaze.eco.core.Entity;

class DefaultStateMachine {

	public var owner:Entity;

	public var currentState(default,null):IState;
	public var previousState(default,null):IState;
	public var globalState:IState;
	
	public function new(owner:Entity) {
		this.owner = owner;
	}

	public function changeState(newState:IState) {
		if (newState==currentState)
			return;

		previousState = currentState;

		if (currentState != null) currentState.exit(owner);

		currentState = newState;

		if (currentState != null) currentState.enter(owner);
	}

	public function update() {
		if (globalState != null) globalState.update(owner);

		if (currentState != null) currentState.update(owner);
	}

}

class TestState implements IState {
	public function new() {};
	public function enter(entity:Entity) {}
	public function update(entity:Entity) {}
	public function exit(entity:Entity) {}
	public function message(entity:Entity,message:Dynamic):Void {};

}