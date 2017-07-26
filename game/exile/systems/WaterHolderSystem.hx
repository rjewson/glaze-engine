package exile.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Display;
import glaze.engine.components.State;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.components.PhysicsBody;


class WaterHolderSystem extends System {
	
    public function new() {
        super([PhysicsCollision,PhysicsBody,exile.components.WaterHolder]);
        this.hasUpdate = false;
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        collision.proxy.contactCallbacks.push(onCollision);
	}

	override public function entityRemoved(entity:Entity) {
	}

	override public function update(timestamp:Float,delta:Float) {
	}


    function onCollision(a:BFProxy,b:BFProxy,c:Contact) {
        var delta = a.body.velocity.clone();
        delta.minusEquals(a.body.previousVelocity);
        // trace(delta);
        if (delta.length()>70) {
            trace(delta.length());
            // js.Lib.debug();
            trace("spilllll");
        }
    	// if (glaze.util.Random.RandomBoolean(0.1)) {
    	// 	b.body.position.copy(a.entity.getComponent(Teleporter).teleportPosition);
    	// }
    }

}