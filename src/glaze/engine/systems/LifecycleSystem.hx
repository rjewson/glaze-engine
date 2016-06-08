package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.LifeCycle;
import glaze.engine.core.EngineLifecycle;

class LifecycleSystem extends System {

    public function new() {
        super([LifeCycle]);
    }

    override public function entityAdded(entity:Entity) {
        var lifecycle = entity.getComponent(LifeCycle);
        lifecycle.state.changeState(entity,EngineLifecycle.INITALIZE);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

}