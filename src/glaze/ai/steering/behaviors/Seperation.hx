package glaze.ai.steering.behaviors;

import glaze.ai.steering.behaviors.Seek;
import glaze.ai.steering.SteeringSettings;
import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.Body;
import glaze.physics.components.PhysicsBody;
import glaze.util.Random;

/**
 * ...
 * @author rje
 */

class Seperation extends Behavior
{

	public var seperationDistance:Int;
	public var group:Array<Entity>;

	public function new(group:Array<Entity>,seperationDistance:Int = 10) {
		super(SteeringSettings.wanderWeight, SteeringSettings.wanderPriority);
		this.group = group;
		this.seperationDistance = seperationDistance;
	}

	override public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {
		
		var count = 0;

		for (entity in group) {
			var body = entity.getComponent(PhysicsBody).body;
			if (body!=this.agent) {
				if (body.position.distSqrd(agent.position)<seperationDistance*seperationDistance) {
					result.plusEquals(body.position);
					result.minusEquals(agent.position);
					count++;
				}
			}
		}

		if (count>0) {
			result.multEquals(-1/count);
		}
		result.normalize();
		result.multEquals(seperationDistance);

	}

	
}