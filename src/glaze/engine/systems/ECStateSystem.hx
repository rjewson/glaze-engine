package glaze.engine.systems;

import glaze.ai.behaviortree.BehaviorContext;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.ECState;
import glaze.util.MessageBus;

class ECStateSystem extends System {

    var bus:MessageBus;

    public function new(bus:MessageBus) {
        super([ECState]);
        this.bus = bus;
    }

    override public function entityAdded(entity:Entity) {
        var state = entity.getComponent(ECState);
        state.owner = entity;
        bus.registerAll(state.triggerChannels,state.recieveTrigger);
    }

    override public function entityRemoved(entity:Entity) {
        var state = entity.getComponent(ECState);
        state.owner = null;
        bus.unregisterAll(state.triggerChannels,state.recieveTrigger);
    }

    override public function update(timestamp:Float,delta:Float) {
    }

}