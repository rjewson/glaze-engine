package exile.components;

import exile.components.BirdNest;
import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.eco.core.Entity;
import glaze.util.IntervalDelay;
import glaze.ai.stackfsm.LWStackFSM;

class Bird implements IComponent {

	public var nest:Entity; 

	public var ai:LWStackFSM<Entity>;
	public var ai2:Behavior;
	public var ctx:BehaviorContext;

	public var delay:IntervalDelay;
	public var chaseCheck:IntervalDelay;

	public var target:Entity;

	public function new(nest:Entity) {
		this.nest = nest;
		ai = new LWStackFSM<Entity>();
		delay = new IntervalDelay(1000);
		chaseCheck = new IntervalDelay(100);
	}

}