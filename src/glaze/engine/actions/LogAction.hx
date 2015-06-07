package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;

class LogAction extends Behavior {

    public function new() {   
        super(); 
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 
        trace("tick");
        return Running;
    }

}