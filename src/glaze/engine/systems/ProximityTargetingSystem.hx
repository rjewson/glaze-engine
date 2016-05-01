package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;

class ProximityTargetingSystem extends System {

    public function new(holderFilterCategory:Int) {
        super([PhysicsCollision,Extents,Holdable]);
        this.holderFilterCategory = holderFilterCategory;
    }

    override public function entityAdded(entity:Entity) {
        var physicsCollision = entity.getComponent(PhysicsCollision);
        physicsCollision.proxy.filter.categoryBits |= holderFilterCategory;    
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

}