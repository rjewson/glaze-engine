package glaze.util;

import glaze.engine.components.State;
import glaze.signals.Signal1;
import haxe.ds.StringMap;

class StateChangeProxy {
	
	public var map:StringMap<State->Void>;

	public function new() {
		map = new StringMap<State->Void>();
	}

	public function registerState(state:State) {
		state.onChanged.add(onStateChange);
	}

	public function onStateChange(state:State) {
		var f = map.get(state.getState());
		if (f!=null)
			f(state);
	}

	public function unregisterState(state:State) {
		state.onChanged.remove(onStateChange);
	}

	public function registerStateHandler(stateName:String,f:State->Void) {
		map.set(stateName,f);
	}

	public function unregisterStateHandler(stateName:String) {
		map.remove(stateName);
	}

}