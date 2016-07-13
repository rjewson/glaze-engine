package exile.components;

import glaze.ai.fsm.LightStackStateMachine;
import glaze.ai.fsm.LightStateMachine;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;

class Grenade implements IComponent {

	public var fuse:Float = 1000;
	public var pause:Float = -1;
	public var state:LightStackStateMachine<Entity>;

	public function new() {
		state = new LightStackStateMachine<Entity>();
	}

} 