package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.ai.steering.behaviors.Arrival;
import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.geom.Vector2;

class WanderToTarget extends Behavior {

	var arrivalZone:Float;

    public function new(arrivalZone:Float = 128) {
        super();
        this.arrivalZone = arrivalZone;
    }

    override private function initialize(context:BehaviorContext):Void {
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 
    	var target:Vector2 = cast Reflect.field(context.data,"target");
    	if (target==null)
    		return Failure;

        var steering = context.entity.getComponent(Steering);

        var wander:Wander = cast steering.getBehaviour(Wander);
        wander.active = true;
        var arrival:Arrival = cast steering.getBehaviour(Arrival);
        arrival.target = target;
        arrival.arrivalZone = arrivalZone;

        return Success;
    }

}