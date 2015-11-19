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

	public function new() {
		super(SteeringSettings.wanderWeight, SteeringSettings.wanderPriority);
		circleRadius = 8;
		circleDistance = 1;
		wanderAngle = Random.RandomFloat(0, Math.PI * 2);
		wanderChange = 4;
	}

	override public function calculate(agent:Body,result:Vector2) {

// js.Lib.debug();
		// var circleCenter = agent.delta.clone();
		var circleCenter = agent.velocity.clone();
		circleCenter.normalize();
		circleCenter.multEquals(circleDistance);

		var displacement = new Vector2(0,-1);
		displacement.multEquals(circleRadius);
		displacement.setAngle(wanderAngle); 

		// wanderAngle += Random.RandomFloat( -wanderChange, wanderChange);
		wanderAngle += Math.random() * wanderChange - wanderChange * .5;

		result.plusEquals(circleCenter);
		result.plusEquals(displacement);
		//result.multEquals(0.1);
		// glaze.ai.steering.behaviors.Seek.calc(agent,result,result.clone());
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