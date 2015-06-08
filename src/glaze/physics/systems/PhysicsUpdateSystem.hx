package glaze.physics.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;

class PhysicsUpdateSystem extends System {
    
    public var globalForce:Vector2;
    public var globalDamping:Float;

    public function new() {
        super([Position,PhysicsBody]);
        globalForce = new Vector2(0,30); 
        globalDamping = 0.99;
    }

    override public function entityAdded(entity:Entity) {
        var position = entity.getComponent(Position);
        var physics = entity.getComponent(PhysicsBody);
        physics.body.position = position.coords;
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            entity.getComponent(PhysicsBody).body.update(delta/1000,globalForce,globalDamping);
        }

    }
}