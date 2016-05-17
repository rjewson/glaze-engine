package glaze.ai.steering.behaviors;

import glaze.ai.steering.SteeringAgentParameters;
import glaze.ai.steering.SteeringSettings;
import glaze.geom.Vector2;
import glaze.physics.Body;
/**
 * ...
 * @author rje
 */

class Seek extends Behavior
{

	public var target:Vector2;
	public var seekDistSq:Float;

	public function new(target:Vector2,seekDistSq:Float = 0) {
		super(SteeringSettings.seekWeight, SteeringSettings.seekPriority);	
		this.target = target;
		this.seekDistSq = seekDistSq;
	}

	override public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {
		calc(agent,params,result,target,seekDistSq);
	}

	//Hand optimized as called so often
	public static inline function calc(agent : Body, params:SteeringAgentParameters, result:Vector2, target : Vector2, seekDistSq : Float = 0):Bool {
		// js.Lib.debug();		
		var dX:Float = target.x - agent.position.x +0.000001;
		var dY:Float = target.y - agent.position.y +0.000001;
		var d:Float = dX * dX + dY * dY;
		// trace(seekDistSq);
		// if ((seekDistSq < 0 && d < -seekDistSq) || (seekDistSq > 0 && d > seekDistSq)) {
		if (seekDistSq > 0 && d < seekDistSq) {
			return false;
		}

		var t = Math.sqrt(d);

		result.x = dX / t;
		result.x *= params.maxSteeringForcePerStep;
		result.x -= agent.velocity.x;//*(16/1000);
		
		result.y = dY / t;
		result.y *= params.maxSteeringForcePerStep;
		result.y -= agent.velocity.y;//*(16/1000);
// trace(result);
// trace(agent.velocity);
		return true;
	}
	
}