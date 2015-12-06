package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Holder;
import glaze.engine.components.Inventory;

class InventorySystem extends System {

    public function new() {
        super([Inventory,Holder]);
    }

    override public function entityAdded(entity:Entity) {
        entity.getComponent(Inventory).storeCB = store;
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
    }

/*
    holder & 4 slots
    [0]0000

    [1]0000
    store
    [0]1000
    retrieve
    [1]0000

    [1]0000
    store
    [0]1000
    pickup
    [2]1000
    store
    [0]2100


*/

    function store(inventory:Inventory) {
        var entity = findEntity(inventory);
        if (entity!=null) {
            var holder = entity.getComponent(Holder);
            if (inventory.isFull())
                return;
        } 
    }

    function retrieve(inventory:Inventory) {
        var entity = findEntity(inventory);
        if (entity!=null) {
            var holder = entity.getComponent(Holder);

        } 
    }

    function findEntity(inventory:Inventory):Entity {
        for (entity in view.entities) {
            if (entity.getComponent(Inventory)==inventory)
                return entity;
        }
        return null;
    }

}