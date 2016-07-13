package glaze.ai.fsm;

import glaze.eco.core.Entity;

typedef LWFSMState<T> = T->LightStackStateMachine<T>->Float->Void;

typedef LWFSME = glaze.ai.fsm.LightStackStateMachine<Entity>;

class LightStackStateMachine<T> {

	public var stack:Array<LWFSMState<T>>;

	public function new() {
		stack = new Array<LWFSMState<T>>();
	}

	public function update(target:T,delta:Float) {
        var currentState = getCurrentState();
 
        if (currentState != null) {
            currentState(target,this,delta);
        }
    }

	public function popState():LWFSMState<T> {
        var state = stack.pop();
        return state;
    }
 
    public function popAllStates() {
        while (stack.length>0)
            popState();
    }

    public function pushState(state:LWFSMState<T>) {
        stack.push(state);
    }

    public function setState(state:LWFSMState<T>) {
        popState();
        pushState(state);
    }

    public function resetState(state:LWFSMState<T>) {
        popAllStates();
        pushState(state);
    }


	public function getCurrentState():LWFSMState<T> {
        return stack.length > 0 ? stack[stack.length - 1] : null;
    } 

}
