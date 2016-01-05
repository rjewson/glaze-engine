package glaze.engine.components;

import glaze.ds.Queue;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.engine.components.Holder;

class Inventory implements IComponent {

	public var slots:Queue<Entity>;
	public var count:Int;
	public var storeCB:Inventory->Void; 
	public var retrieveCB:Inventory->Void; 
 
	public function new(slotCount:Int) {
		slots = new Queue(slotCount);
	}
	
	public function store() {
		if (storeCB!=null)
			storeCB(this);
	}

	public function retrieve() {
		if (retrieveCB!=null)
			retrieveCB(this);
	}

	public function toString() {
		var result = "";
		for (item in slots.data)
			result+=item.name + ":";
		return result;
	}

}