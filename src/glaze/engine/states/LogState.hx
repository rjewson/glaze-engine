package glaze.engine.states;

import glaze.ai.stackfsm.StackFSM.FSMState;
import glaze.engine.states.DelayState;
import glaze.util.IntervalDelay;

class LogState extends FSMState {

    public override function update(delta:Float) {
    	trace("Working OK");
    	fsm.pushState(new DelayState(1000));
    }

}