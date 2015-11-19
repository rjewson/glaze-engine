package exile.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;

class BeeHive implements IComponent {

	public var maxBees:Int;
	public var bees:Array<Entity>;

	public function new(maxBees:Int) {
		this.maxBees = maxBees;
		bees = new Array<Entity>();
	}

}