package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Health;

class HealthSystem extends System {

    public function new() {
        super([Health]);
    }

    override public function entityAdded(entity:Entity) {
        // var health = entity.getComponent(Health);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var health = entity.getComponent(Health);
            health.currentHealth = Math.min(health.maxHealth,health.currentHealth+(health.recoveryPerMs*delta));
        }
    }

}