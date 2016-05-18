package glaze.ai.steering.components;

import glaze.ai.steering.behaviors.Behavior;
import glaze.ai.steering.SteeringAgentParameters;
import glaze.ai.steering.SteeringBehavior;
import glaze.eco.core.IComponent;

class Steering implements IComponent {
    
	public static inline var CALCULATE_SUM:Int = 0;
	// Simply adds up all of the behaviors and truncates them to the max acceleration
	public static inline var CALCULATE_SPEED:Int = 1;
	// Prioritized Dithering
	public static inline var CALCULATE_ACCURACY:Int = 2;
    
	public var behaviors:Array<Behavior>;
	public var calculateMethod:Int;
    public var steeringParameters:SteeringAgentParameters;
    public var hasChanged:Bool;

	public function new(behaviors:Array<Behavior>, params:SteeringAgentParameters = null,calculationMethod:Int = CALCULATE_SUM) {
		this.behaviors = behaviors;
		this.steeringParameters = params==null ? SteeringAgentParameters.DEFAULT_STEERING_PARAMS : params;
		this.hasChanged = true;
	}

	public function addBehavior(behavior:Behavior) {
		behaviors.push(behavior);
		hasChanged = true;
	}
	
	public function removeBehaviour(behavior:Behavior) {
		behaviors.remove(behavior);
		hasChanged = true;
	}


}