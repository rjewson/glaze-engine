package glaze.engine.components;

import glaze.ai.fsm.LightStateMachine;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.signals.Signal1;

class LifeCycle implements IComponent {

	public var state:LightStateMachine;

	public function new(states:LightStateSet) {
		state = new LightStateMachine(states);
	}

}