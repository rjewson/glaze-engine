package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.physics.components.PhysicsBody;

class PhysicsPositionSystem extends System {
    
    public function new() {
        super([Position,PhysicsBody]);
    }

    override public function entityAdded(entity:Entity) {
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            entity.getComponent(PhysicsBody).body.updatePosition();
        }
    }
}