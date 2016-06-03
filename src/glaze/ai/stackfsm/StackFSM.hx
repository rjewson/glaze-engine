package glaze.ai.stackfsm;

import glaze.eco.core.Entity;

// typedef FSMState = Entity->StackFSM->Float->Void;

class StackFSM {

    public var entity:Entity;
	public var stack:Array<FSMState>;

	public function new(entity:Entity = null) {
        this.entity = entity;
		stack = new Array<FSMState>();
	}

	public function update(delta:Float) {
        var currentState = getCurrentState();
 
        if (currentState != null) {
            currentState.update(delta);
        }
    }

	public function popState():FSMState {
        var state = stack.pop();
        if (state!=null)
            state.leave();
        return state;
    }
 
    public function pushState(state:FSMState) {
        state.fsm = this; 
        state.enter();
        stack.push(state);
    }

	public function getCurrentState():FSMState {
        return stack.length > 0 ? stack[stack.length - 1] : null;
    } 

}

class FSMState {

    public var fsm:StackFSM;

    public function new() {}

    public function enter() {}
    
    public function update(delta:Float) {}

    public function leave() {}

}