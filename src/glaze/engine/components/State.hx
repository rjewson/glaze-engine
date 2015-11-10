package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.signals.Signal1;

class State implements IComponent {
    
	public var states:Array<String>;
	public var currentState:Int;
	public var owner:Entity;
	public var onChanged:Signal1<State>;

	public var triggerChannels:Array<String>;

	public function new(states:Array<String>, initialStateIndex:Int, triggerChannels:Array<String>) {
		this.states = states;
		this.currentState = initialStateIndex;
		this.triggerChannels = triggerChannels;
		this.onChanged = new Signal1<State>();
	}

	public function getState() {
		return states[currentState];
	}

	public function incrementState() {
		currentState+=1;
		if (currentState>=states.length)
			currentState = 0;
		onChanged.dispatch(this);
	}

	public function recieveTrigger(data:Dynamic) {
		incrementState();
	}

}