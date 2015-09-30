package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Holder implements IComponent {

	public var hold:Bool = false;
	public var heldItem:Entity = null;

    public function new() {
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