package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;

class Delay extends Behavior {

    private var delay:Float;
    private var elapsed:Float;

    public function new(delay:Float) {
        super();
        this.delay = delay;
    }

    override private function initialize(context:BehaviorContext):Void {
        elapsed = 0;
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 
        elapsed+=context.time;
        if (elapsed>delay) {
            return Success;
        }
        return Running;
    }

}