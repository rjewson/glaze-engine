package exile.components;

import glaze.eco.core.IComponent;
import glaze.util.IntervalDelay;

class GunTurret implements IComponent {

	public var intervalDelay:IntervalDelay;

	public function new() {
		intervalDelay = new IntervalDelay(1000);
	}

}