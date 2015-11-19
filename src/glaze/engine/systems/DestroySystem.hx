package glaze.engine.systems;

import glaze.ai.behaviortree.BehaviorContext;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Destroy;
import glaze.engine.components.Script;

class DestroySystem extends System {

    public function new() {
        super([Destroy]);
    }

    override public function entityAdded(entity:Entity) {
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        var count = view.entities.length;
        var next = 0;
        while (count>0) {
            var entity = view.entities[next];
            if ((entity.getComponent(Destroy).count--)<=0) {
                entity.destroy();
            } else {
                next++;
            }
            count--;
        }
    }

}