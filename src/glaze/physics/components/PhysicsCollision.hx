package glaze.physics.components;

import glaze.eco.core.IComponent;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Filter;

class PhysicsCollision implements IComponent {
    
    public var proxy:BFProxy;

    public function new(isSensor:Bool,filter:Filter,contactCallbacks:Array<ContactCallback>) {
        proxy = new BFProxy();
        proxy.isSensor = isSensor;
        proxy.filter = filter;
    	proxy.contactCallbacks = contactCallbacks;
    }

}