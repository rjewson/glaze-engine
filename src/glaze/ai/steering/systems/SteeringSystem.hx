package glaze.ai.steering.systems;

import glaze.ai.steering.behaviors.Behavior;
import glaze.ai.steering.components.Steering;
import glaze.ai.steering.SteeringBehavior;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.geom.Vector2;
import glaze.physics.Body;
import glaze.physics.components.PhysicsBody;

class SteeringSystem extends System {

    var behaviorForce:Vector2;
    var totalForce:Vector2;

    public function new() {
        super([PhysicsBody,Steering]);
        behaviorForce = new Vector2();
        totalForce = new Vector2();
    }

    override public function entityAdded(entity:Entity) {
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var body = entity.getComponent(PhysicsBody).body;
            var steering = entity.getComponent(Steering);

            if (steering.hasChanged) {
                steering.behaviors.sort(behaviorsCompare);
                steering.hasChanged = false;
            }
            runningSum(steering,body);
            // js.Lib.debug();
            body.addProportionalForce(totalForce);
            // body.addForce(totalForce);
        }
    }

    private function runningSum(steering:Steering,agent:Body) {
        totalForce.setTo(0,0);
        for (behavior in steering.behaviors) {
            behaviorForce.setTo(0,0);
            behavior.calculate(agent,steering.steeringParameters,behaviorForce);
            behaviorForce.multEquals(behavior.weight);
            totalForce.plusEquals(behaviorForce);
         }
        // js.Lib.debug();
        totalForce.clampScalar(steering.steeringParameters.maxAcceleration);
    }

    private function behaviorsCompare(a:Behavior,b:Behavior):Int {
        if ( a.priority < b.priority ) return -1;
        if ( a.priority == b.priority ) return 0;
        return 1;
    }

}