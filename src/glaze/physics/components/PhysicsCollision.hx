package glaze.physics.components;

import glaze.eco.core.IComponent;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Filter;

class PhysicsCollision implements IComponent {
    
    public var isSensor:Bool = false;
    public var filter:Filter = null;
    public var contactCallback:ContactCallback = null;

    public var proxy:BFProxy;

    public function new(isSensor:Bool,filter:Filter) {
    	this.isSensor = isSensor;
    	this.filter = filter;
    }

}