package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.AI;

class AISystem extends System {

    public function new() {
        super([Active,AI]);
    }

    override public function entityAdded(entity:Entity) {
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        // for (entity in view.entities) {
        //    var ai = entity.getComponent(AI);
        //    for (ai in ai.fsms) {
        //         ai.update(delta);
        //    }
        // }
    }

}