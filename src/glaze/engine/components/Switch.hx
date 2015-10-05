package glaze.engine.components;

import glaze.eco.core.IComponent;

class Switch implements IComponent {

	public var states:Array<String>;
	public var currentState:Int;
	public var callback:String -> Void;

    public function new(states:Array<String>,initialState:Int = 0) {
    	this.states = states;
    	currentState = initialState;
    }

    public function activate() {
    	currentState++;
    	if (currentState==states.length) {
    		currentState = 0;
    	}
    	callback(states[currentState]);
    }


}