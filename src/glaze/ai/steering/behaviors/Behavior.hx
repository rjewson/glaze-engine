package glaze.ai.steering.behaviors;

import glaze.ai.steering.SteeringAgentParameters;
import glaze.ai.steering.SteeringBehavior;
import glaze.physics.Body;
import glaze.geom.Vector2;

/**
 * ...
 * @author rje
 */

class Behavior 
{
	public var weight : Float;
	public var probability : Float;
	public var priority : Int;
	public var agent : Body;
	public var active : Bool;
	
	public var steering:SteeringBehavior;
		
	public function new(weight:Float = 1.0,priority:Int=1,probability:Float = 1,active:Bool=true) 
	{
		this.weight = weight;
		this.priority = priority;
		this.probability = probability;
		this.active = active;
	}
	
	public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {
	}	
	
}