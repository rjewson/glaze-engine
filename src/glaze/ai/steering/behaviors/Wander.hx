package glaze.ai.steering.behaviors;

import glaze.ai.steering.behaviors.Seek;
import glaze.ai.steering.SteeringSettings;
import glaze.geom.Vector2;
import glaze.physics.Body;
import glaze.util.Random;

/**
 * ...
 * @author rje
 */

class Wander extends Behavior
{
	public var circleRadius:Int;
	public var circleDistance:Int;
	public var wanderAngle : Float;
	public var wanderChange : Float;

	var circleCenter:Vector2 = new Vector2();
	var displacement:Vector2 = new Vector2();

	public function new(circleRadius:Int = 8,circleDistance:Int = 1,wanderChange:Float = 4) {
		super(SteeringSettings.wanderWeight, SteeringSettings.wanderPriority);
		this.circleRadius = circleRadius;
		this.circleDistance = circleDistance;
		wanderAngle = Random.RandomFloat(0, Math.PI * 2);
		this.wanderChange = wanderChange;
	}

	override public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {

		wanderAngle += Random.RandomFloat( -wanderChange, wanderChange);

		circleCenter.copy(agent.velocity);
		circleCenter.normalize();
		circleCenter.multEquals(circleDistance);
		circleCenter.plusEquals(agent.position);

// glaze.debug.DebugEngine.DrawParticle(circleCenter.x,circleCenter.y,4,0,0,255);

		var h:Float = Math.atan2(agent.velocity.y, agent.velocity.x);
		h+=Math.PI/2;
		displacement.setTo(circleRadius * Math.cos(wanderAngle + h), circleRadius * Math.sin(wanderAngle + h));

		circleCenter.plusEquals(displacement);

// glaze.debug.DebugEngine.DrawParticle(circleCenter.x,circleCenter.y,4,255,0,0);

		Seek.calc(agent,params,result,circleCenter,0);
	}

	
}