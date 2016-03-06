package glaze.physics.systems;

import glaze.eco.core.System;
import glaze.eco.core.Entity;
import glaze.engine.components.Extents;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsConstraints;

class PhysicsMassSystem extends System {
    
    public function new() {
        super([PhysicsBody,Extents]);
        hasUpdate = false;
    }

    override public function entityAdded(entity:Entity) {
        var extents = entity.getComponent(Extents);
        var body = entity.getComponent(PhysicsBody);
        if (body.setMassFromVolume) {
            body.body.setMassFromVolumeMaterial(extents.halfWidths.x*extents.halfWidths.y*4);
        }
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }
}