package glaze.engine.components;

import glaze.ds.Queue;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.engine.components.Holder;
import haxe.ds.StringMap;

class Inventory implements IComponent {

	public var slots:Queue<Entity>;
	public var count:Int;
	public var storeCB:Inventory->Void; 
	public var retrieveCB:Inventory->Void; 
 
	public var permanentItems:StringMap<Int>;

	public function new(slotCount:Int) {
		slots = new Queue(slotCount);
		permanentItems = new haxe.ds.StringMap<Int>();
	}
	
	public function store() {
		if (storeCB!=null)
			storeCB(this);
	}

	public function retrieve() {
		if (retrieveCB!=null)
			retrieveCB(this);
	}

	public function storePerm(type:String,value:Int) {
		if (!permanentItems.exists(type)) {
			permanentItems.set(type,0);
		}
		var currentValue = permanentItems.get(type);
		permanentItems.set(type,currentValue+value);

		trace("PermStored:{type}+{value}");
		js.Lib.debug();
	}

	public function toString() {
		var result = "";
		for (item in slots.data)
			result+=item.name + ":";
		return result;
	}

}