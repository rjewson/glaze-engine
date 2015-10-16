package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Age implements IComponent {
    
	public var creationTimestamp:Float;
	public var ttl:Float;
	public var age:Float;
	
    public function new(ttl:Int) {
    	this.ttl = ttl;
    	this.age = ttl;
    }

}