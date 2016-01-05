package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.geom.Vector2;
import glaze.physics.constraint.Spring;

class Holder implements IComponent {

	public var activate:Bool = false;
	public var heldItem:Entity = null;

    public function new() {
    }

	public function hold(item:Entity,holderEntity:Entity) {
	    if (heldItem==null && item.getComponent(Held)==null) {
	        var held = new Held();
	        held.holder = holderEntity;
	        item.addComponent(held);
	        heldItem = item;        
	    }
	}

    public function drop() {
	    if (heldItem!=null) {
	    	var _heldItem = heldItem;
	        heldItem.removeComponent(heldItem.getComponent(Held));
	        heldItem = null;
	        return _heldItem;
	    }
	    return null;
    }

}