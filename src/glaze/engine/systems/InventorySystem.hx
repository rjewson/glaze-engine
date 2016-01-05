package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.Holder;
import glaze.engine.components.Inventory;

class InventorySystem extends System {

    public function new() {
        super([Inventory,Holder]);
    }

    override public function entityAdded(entity:Entity) {
        entity.getComponent(Inventory).storeCB = store;
        entity.getComponent(Inventory).retrieveCB = retrieve;
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
            if (holder.heldItem!=null && !inventory.slots.isFull()) {
                var item = holder.drop();
                item.removeComponent(item.getComponent(Active));
                inventory.slots.enqueue(item);
                trace(inventory.toString());
            }            
        } 
    }

    function retrieve(inventory:Inventory) {
        var entity = findEntity(inventory);
        if (entity!=null) {
            var holder = entity.getComponent(Holder);
            var nextItem = inventory.slots.dequeue();
            if (nextItem!=null) {
                if (holder.heldItem!=null) {
                    var item = holder.drop();
                    item.removeComponent(item.getComponent(Active));
                    inventory.slots.enqueue(item);
                }
                nextItem.addComponent(new Active());
                holder.hold(nextItem,entity);
                trace(inventory.toString());
            }
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