package glaze.ai.steering.behaviors;

import glaze.ai.steering.SteeringSettings;
import glaze.geom.Vector2;
import glaze.physics.Body;
/**
 * ...
 * @author rje
 */

class Arrival extends Behavior
{

	public var target:Vector2;
	public var arrivalZone:Float;
	public var seekDist:Float;

	public function new(target:Vector2,arrivalZone:Float = 0,seekDist:Float = 0) {
		super(SteeringSettings.seekWeight, SteeringSettings.seekPriority);	
		this.target = target;
		this.arrivalZone = arrivalZone;
		this.seekDist = seekDist;
	}

	override public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {
		calc(agent,params,result,target,arrivalZone,seekDist);
	}

	//Hand optimized as called so often
	public static inline function calc(agent : Body,params:SteeringAgentParameters, result:Vector2, target : Vector2, arrivalZone:Float = 0, seekDist : Float = 0):Bool {
		var dX:Float = target.x - agent.position.x + 0.000001;
		var dY:Float = target.y - agent.position.y + 0.000001;
		var d:Float = dX * dX + dY * dY;

		if (seekDist > 0 && d < seekDist*seekDist) {
			return false;
		}

		var t = Math.sqrt(d);

		var scale:Float = 1.0;

		if (t<arrivalZone) {
			scale = (t/arrivalZone);
		}

		result.x = dX / t;
		result.x *= params.maxSteeringForcePerStep;
		result.x -= agent.velocity.x*(60/1000);
		result.x *= scale;
		
		result.y = dY / t;
		result.y *= params.maxSteeringForcePerStep;
		result.y -= agent.velocity.y*(60/1000);
		result.x *= scale;

		return true;
	}
	
}