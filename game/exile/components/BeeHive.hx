package exile.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.util.EntityGroup;

class BeeHive implements IComponent {

	public var group:EntityGroup;

	public function new(maxBees:Int) {
		this.group = new EntityGroup(maxBees);
	}

}