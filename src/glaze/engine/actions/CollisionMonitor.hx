package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

@:keep
class CollisionMonitor extends Behavior {

	var physicsCollision:PhysicsCollision;
	var successCount:Int;

	public var totalContactCount:Int = 0;
	public var updateContactCount:Int = 0;

    public function new(successCount:Int=2) {
    	this.successCount = successCount;
        super(); 
    }

    override private function initialize(context:BehaviorContext):Void {
    	context.entity.getComponent(PhysicsCollision).proxy.contactCallbacks.push(onContact);
    }

    function onContact(a:BFProxy,b:BFProxy,contact:Contact) {
        if (b!=null && b.isSensor)
            return;
    	totalContactCount++;
    	updateContactCount++;
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 
        if (totalContactCount>=successCount)
        	return Success;
        return Running;
    }

}