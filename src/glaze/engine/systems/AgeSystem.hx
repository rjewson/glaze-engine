package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.Age;
import glaze.engine.components.LifeCycle;

class AgeSystem extends System {

    public function new() {
        super([Age,Active]);
    }

    override public function entityAdded(entity:Entity) {
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var age = entity.getComponent(Age);
            if (age.growOlder(delta)) {
                if (age.onExpire!=null)
                    age.onExpire(entity);
            }
        }
    }

}