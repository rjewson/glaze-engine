package glaze.ai.steering;

import glaze.ai.steering.behaviors.Behavior;
import glaze.ai.steering.SteeringAgentParameters;
import glaze.physics.Body;
import glaze.geom.Vector2;

/**
 * ...
 * @author rje
 */

// NOT IN USE SEE THE SYSTEM

class SteeringBehavior 
{
	public static inline var CALCULATE_SUM:Int = 0;
	// Simply adds up all of the behaviors and truncates them to the max acceleration
	public static inline var CALCULATE_SPEED:Int = 1;
	// Prioritized Dithering
	public static inline var CALCULATE_ACCURACY:Int = 2;
	// Weighted Truncated Running Sum with Prioritization
	public var behaviors:Array<Behavior>;
	public var neighbors:Array<Body>;
	
	public var calculateMethod:Int;
	private var hasChanged:Bool;
	private var hasGroupBehavior:Bool;
	private var force:Vector2;
	private var behaviorForce:Vector2;
	private var agentParameters:SteeringAgentParameters;
		
	public function new(agentParameters:SteeringAgentParameters,calculationMethod : Int = CALCULATE_SUM) {
		this.agentParameters = agentParameters;
		this.calculateMethod = calculationMethod;
		force = new Vector2();
		behaviorForce = new Vector2();
		behaviors = new Array<Behavior>();
		//neighbors = new Array<Body>();
	}

	public function addBehavior(behavior:Behavior):Void {
		behaviors.push(behavior);
		behavior.steering = this;
		hasChanged = true;
		//if ( behavior is IGroupBehavior ) hasGroupBehavior = true;
	}
	
	public function removeBehaviour(behavior : Behavior) : Void {
		behaviors.remove(behavior);
	}
	
	public function calculate(agent:Body):Vector2 {
		if ( hasChanged ) {
			sort();
			hasChanged = false;
		}
		force.x = 0;
		force.y = 0;
		// FIXME
		// if ( m_hasGroupBehavior ) {
		// neighbors = [];
		// var dist : Number = m_agent.neighborDistance * m_agent.neighborDistance;
		// for each ( var entity:Entity in m_agent.parent.getChildren() ) {
		// if ( entity is Boid && entity.actualPos.distanceSqTo(m_agent.actualPos) < dist ) {
		// neighbors.push(entity);
		// }
		// }
		// }

		switch( calculateMethod ) {
			case CALCULATE_SUM:
				runningSum(agent);
			case CALCULATE_SPEED:
				prioritizedDithering();
			case CALCULATE_ACCURACY:
				wtrsWithPriorization();
		}

		// agent.addForce(force);
		agent.addProportionalForce(force);

		return force;
	}

	private function prioritizedDithering() : Void {
		// for (behavior in behaviors) {
		// 	if ( Math.random() < behavior.probability ) {
		// 		force.plusEquals(behavior.calculate().mult(behavior.weight));
		// 	}

		// 	if ( !force.equalsZero() ) {
		// 		force.clampMax(agent.maxAcceleration);
		// 		return;
		// 	}
		// }
	}

	private function wtrsWithPriorization() : Void {
		// for (behavior in behaviors) {
		// 	if ( !accumulateForce(force, behavior.calculate().mult(behavior.weight))) 
		// 		return;
		// }
	}

	private function runningSum(agent:Body) : Void {
		for (behavior in behaviors) {
			behavior.calculate(agent,agentParameters,behaviorForce);
			behaviorForce.multEquals(behavior.weight);
			force.plusEquals(behaviorForce);
			//force.plusEquals(behavior.calculate().mult(behavior.weight));
		}
		force.clampScalar(agentParameters.maxAcceleration);
	}

	private function accumulateForce(a_runningTotal : Vector2, a_forceToAdd : Vector2) : Bool {
		// var magnitudeSoFar : Float = a_runningTotal.length();
		// var magnitudeRemaining : Float = agent.maxAcceleration - magnitudeSoFar;
		// if ( magnitudeRemaining <= 0 ) 
		// 	return false;

		// var magnitudeToAdd : Float = a_forceToAdd.length();

		// if ( magnitudeToAdd < magnitudeRemaining ) {
		// 	a_runningTotal.x += a_forceToAdd.x;
		// 	a_runningTotal.y += a_forceToAdd.y;
		// 	return true;
		// } else {
		// 	a_runningTotal.plusEquals(a_forceToAdd.unit().multEquals(magnitudeRemaining));
		// 	return false;
		// }
		return false;
	}
	
	private function sort() : Void {
		behaviors.sort(behaviorsCompare);
	}

	private function behaviorsCompare(a : Behavior, b : Behavior) : Int {
		if ( a.priority < b.priority ) return -1;
		if ( a.priority == b.priority ) return 0;
		return 1;
	}
	
}