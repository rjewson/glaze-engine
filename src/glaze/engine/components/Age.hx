package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.engine.core.EngineLifecycle;
import glaze.geom.Vector2;

class Age implements IComponent {
    
	public var creationTimestamp:Float;
	public var ttl:Float;
	public var age:Float;
	
	public var stateOnExpired:String = EngineLifecycle.DESTROY;


    public function new(ttl:Int) {
    	this.ttl = ttl;
    	this.age = 0;
    }

    public function growOlder(tick:Float):Bool {
    	age+=tick;
    	return isExpired();
    }

	public inline function isExpired():Bool {
		return age>ttl;
	}

	public function reset() {
		age = 0;
	}

}