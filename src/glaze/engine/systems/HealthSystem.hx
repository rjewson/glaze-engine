package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.Health;
import glaze.engine.components.LifeCycle;

class HealthSystem extends System {

    public function new() {
        super([Health,Active]);
    }

    override public function entityAdded(entity:Entity) {
        // var health = entity.getComponent(Health);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var health = entity.getComponent(Health);
            if (health.currentHealth<=0) {
                if (health.onNoHealth!=null) {
                    health.onNoHealth(entity);
                }
            } else {
                health.currentHealth = Math.min(health.maxHealth,health.currentHealth+(health.recoveryPerMs*delta));                
            }
        }
    }

}