package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.engine.components.Position;
import glaze.geom.Vector2;

class CanSee extends Behavior {

	var range:Float;

    public function new(range:Float = 300) {
        super();
        this.range = range;
    }

    override private function initialize(context:BehaviorContext):Void {
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 

     	var target:Vector2 = cast Reflect.field(context.data,"target");
    	if (target==null)
    		return Failure;

		if (glaze.util.CombatUtils.canSee(context.entity.getComponent(Position).coords,target,range)) 
            return Success;

        return Failure;
    }

}