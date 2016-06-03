package glaze.engine.states;

import glaze.ai.stackfsm.StackFSM.FSMState;
import glaze.util.IntervalDelay;

class DelayState extends FSMState {

	public var delay:IntervalDelay;

	public function new(delayTime:Float) {
		super();
		delay = new IntervalDelay(delayTime);
	}

    public override function update(delta:Float) {
    	if (delay.tick(delta)) {
    		fsm.popState();
    	}
    }

}