package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.eco.core.Entity;
import glaze.physics.components.ContactRouter;
import glaze.physics.components.PhysicsCollision;

class ContactRouterSystem extends System {
    
    public function new() {
        super([PhysicsCollision,ContactRouter]);
    }

    override public function entityAdded(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        var router = entity.getComponent(ContactRouter);
        collision.setCallback(router.calback);
        js.Lib.debug();
    }
    
    override public function entityRemoved(entity:Entity) {
        var collision = entity.getComponent(PhysicsCollision);
        collision.setCallback(null);
    }

    override public function update(timestamp:Float,delta:Float) {
    }
}