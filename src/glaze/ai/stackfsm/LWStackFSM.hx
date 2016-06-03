package glaze.ai.stackfsm;

import glaze.eco.core.Entity;

typedef LWFSMState<T> = T->LWStackFSM<T>->Float->Void;

typedef LWFSME = glaze.ai.stackfsm.LWStackFSM<Entity>;

class LWStackFSM<T> {

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
 
    public function pushState(state:LWFSMState<T>) {
        stack.push(state);
    }

	public function getCurrentState():LWFSMState<T> {
        return stack.length > 0 ? stack[stack.length - 1] : null;
    } 

}
