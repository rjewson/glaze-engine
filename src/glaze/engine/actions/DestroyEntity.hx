package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;

class DestroyEntity extends Behavior {


    public function new() {
        super();
    }

    override private function update(context:BehaviorContext):BehaviorStatus {
    	// js.Lib.debug(); 
        context.entity.engine.destroyEntity(context.entity);
        return Success;
    }

}