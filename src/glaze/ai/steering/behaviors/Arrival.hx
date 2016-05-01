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

	override public function calculate(agent:Body,result:Vector2) {
		calc(agent,result,target,arrivalZone,seekDist);
	}

	//Hand optimized as called so often
	public static inline function calc(agent : Body, result:Vector2, target : Vector2, arrivalZone:Float = 0, seekDist : Float = 0):Bool {
		// js.Lib.debug();		
		var dX:Float = target.x - agent.position.x +0.000001;
		var dY:Float = target.y - agent.position.y +0.000001;
		var d:Float = dX * dX + dY * dY;
		// trace(seekDistSq);
		// if ((seekDistSq < 0 && d < -seekDistSq) || (seekDistSq > 0 && d > seekDistSq)) {
		// if (seekDistSq > 0 && d < seekDistSq) {
		// 	return false;
		// }

		if (seekDist > 0 && d < (seekDist*seekDist)) {
			return false;
		}

		var t = Math.sqrt(d);

		var scale = 100.0;
		if (t<arrivalZone) {
			// scale = (t+seekDist)/(arrivalZone+seekDist);
			scale = (t)/(arrivalZone);
			// scale = 1/scale;
			// scale = 1-scale;
			// trace(t,scale);
			scale*=100;
		}		

		result.x = dX / t;
		result.x *= scale;
		result.x -= agent.velocity.x*(16/1000);
		
		result.y = dY / t;
		result.y *= scale;//agent.maxSteeringForcePerStep;
		result.y -= agent.velocity.y*(16/1000);

		return true;
	}
	
}