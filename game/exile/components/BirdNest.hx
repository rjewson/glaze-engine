package exile.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.util.EntityGroup;
import glaze.util.IntervalDelay;

class BirdNest implements IComponent {

	public var group:EntityGroup;
 
	public var trigger:Entity;
	public var triggered:Bool = false;
	
	public var radius:Int = 100;

	public var intervalDelay:IntervalDelay;

	public function new(maxBirds:Int) {
		this.group = new EntityGroup(maxBirds);
		intervalDelay = new IntervalDelay(1000);
	}

}