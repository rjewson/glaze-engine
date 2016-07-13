package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.engine.core.EngineLifecycle;

class CollisionCounter implements IComponent {

	public var count:Float;
	public var onCount:Entity->Void;
	public var ignoreStatic:Bool;

	public function new(count:Float,onCount:Entity->Void,ignoreStatic:Bool = true) {
	    this.count = count;
	    this.onCount = onCount;
	    this.ignoreStatic = ignoreStatic;
	}

}