package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class CollisionMonitor extends Behavior {

	var physicsCollision:PhysicsCollision;
	var successCount:Int;

	public var totalContactCount:Int = 0;
	public var updateContactCount:Int = 0;

    public function new(successCount:Int=1) {
    	this.successCount = successCount;
        super(); 
    }

    override private function initialize(context:BehaviorContext):Void {
    	physicsCollision = context.entity.getComponent(PhysicsCollision);
    	if (physicsCollision!=null)
	    	physicsCollision.contactCallback = onContact;
    }

    //BFProxy -> BFProxy -> Contact -> Void;
    function onContact(a:BFProxy,b:BFProxy,contact:Contact) {
    	totalContactCount++;
    	updateContactCount++;
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 
    	trace(totalContactCount);
        if (totalContactCount>=successCount)
        	return Success;
        return Running;
    }

}