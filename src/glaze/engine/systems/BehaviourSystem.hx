package glaze.engine.systems;

import glaze.ai.behaviortree.BehaviorContext;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Script;

class BehaviourSystem extends System {

    public function new() {
        super([Script]);
    }

    override public function entityAdded(entity:Entity) {
        var script = entity.getComponent(Script);
        script.context = new BehaviorContext(entity);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var script = entity.getComponent(Script);
            script.context.timestamp = timestamp;
            script.context.delta = delta;
            script.behavior.tick(script.context);
        }
    }

}