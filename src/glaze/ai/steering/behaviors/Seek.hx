package glaze.ai.steering.behaviors;

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

	override public function calculate(agent:Body,result:Vector2) {
		calc(agent,result,target,seekDistSq);
	}

	//Hand optimized as called so often
	public static inline function calc(agent : Body, result:Vector2, target : Vector2, seekDistSq : Float = 0) {
				
		var dX:Float = target.x - agent.position.x;
		var dY:Float = target.y - agent.position.y;
		var d:Float = dX * dX + dY * dY;
		
		if ((seekDistSq < 0 && d < -seekDistSq) || (seekDistSq > 0 && d > seekDistSq)) {
			return;
		}

		var t = Math.sqrt(d);

		result.x = dX / t;
		result.x *= 10;
		result.x -= agent.velocity.x*(16/1000);
		
		result.y = dY / t;
		result.y *= 10;//agent.maxSteeringForcePerStep;
		result.y -= agent.velocity.y*(16/1000);
	}
	
}