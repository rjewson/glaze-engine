package glaze.ai.fsm;

import glaze.ai.fsm.IState;
import glaze.eco.core.Entity;

typedef LightStateSet = Map<String,Entity->Void>;

/*
	The LightStateMachine takes a common (singelton for example) list of functions, 1 per state referenced by a string ID
	The function is only executed once, on valid state change.
	This is idea of low memory situations e.g.
	- manage the state of a world object e.g. door
	- simple lifecyle work e.g. destroy, cleanup
*/

class LightStateMachine {

	public var states:LightStateSet;

	public var currentState(default,null):String;
	
	public function new(states:LightStateSet) {
		this.states = states;
	}

	public function changeState(owner:Entity,newState:String):String {
		if (newState==currentState)
			return currentState;

		if (!states.exists(newState))
			return currentState;

		currentState = newState;

		states.get(newState)(owner);

		return newState;
	}

}