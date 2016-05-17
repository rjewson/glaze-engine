package glaze.ai.steering.behaviors;

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
		this.circleDistance = circleRadius;
		wanderAngle = Random.RandomFloat(0, Math.PI * 2);
		this.wanderChange = wanderChange;
	}

	override public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {

// js.Lib.debug();
		// var circleCenter = agent.delta.clone();
		
		// var circleCenter = agent.velocity.clone();
		circleCenter.copy(agent.velocity);
		circleCenter.normalize();
		circleCenter.multEquals(circleDistance);

		// var displacement = new Vector2(0,-1);
		displacement.setTo(-1,0);
		displacement.multEquals(circleRadius);
		displacement.setAngle(wanderAngle); 

		wanderAngle += Random.RandomFloat( -wanderChange, wanderChange);
		// wanderAngle += 0.08;//wanderChange;
		// wanderAngle += (Math.random() * wanderChange) - (wanderChange * .5);
// trace(wanderAngle);

		var x:Vector2 = agent.position.clone();
		//x.setTo(0,0);
		x.plusEquals(circleCenter);
		x.plusEquals(displacement);

		//x.multEquals(params.maxSteeringForcePerStep);

		// result.copy(x);
		// trace(result.x,result.y);
		glaze.ai.steering.behaviors.Seek.calc(agent,params,result,x,0);
		// trace(result.x,result.y);

	}


	// public override function calculate2() : Vector2 {
		
	// 	wanderAngle += Random.RandomFloat( -wanderChange, wanderChange);
	// 	var v:Vector2 = agent.GetVelocity();
	// 	var circleLoc:Vector2 = v.clone();
	// 	circleLoc.unitEquals();
	// 	circleLoc.multEquals(circleDistance);
	// 	circleLoc.plusEquals(agent.position);
				
	// 	var h:Float = -Math.atan2(-v.y, v.x);
		
	// 	var circleOffset:Vector2 = new Vector2(circleRadius * Math.cos(wanderAngle + h), circleRadius * Math.sin(wanderAngle + h));
	// 	var target = circleLoc.plus(circleOffset);

	// 	return Seek.calc(agent, target);
	// }
	
}