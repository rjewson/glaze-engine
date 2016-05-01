package exile.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.util.IntervalDelay;

enum NestState {
	SLEEPING;
	WANDERING;
	ATTACKING;
	RETURNING;
}

class BirdNest implements IComponent {

	public var maxBirds:Int;
	public var birds:Array<Entity>;

	public var state:NestState;

	public var trigger:Entity;
	public var triggered:Bool = false;
	
	public var radius:Int = 100;

	public var intervalDelay:IntervalDelay;

	public function new(maxBirds:Int) {
		this.maxBirds = maxBirds;
		birds = new Array<Entity>();
		state = SLEEPING;
		intervalDelay = new IntervalDelay(1000);
	}

}