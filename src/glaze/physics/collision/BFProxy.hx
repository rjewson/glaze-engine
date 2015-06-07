
package glaze.physics.collision;

import glaze.geom.AABB;
import glaze.physics.Body;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.collision.Filter;

class BFProxy 
{

    public var aabb:AABB;
    public var body:Body;

    public var isStatic:Bool = false;
    public var isSensor:Bool = false;

    public var filter:Filter;
    public var material:Material;

    public var contactCallback :  BFProxy -> BFProxy -> Contact -> Void = null;

    public function new() {
    }

    public static inline function CreateStaticFeature(x:Float,y:Float,hw:Float,hh:Float):BFProxy {
        var bfproxy = new BFProxy();
        bfproxy.aabb = new AABB();
        bfproxy.aabb.position.setTo(x,y);
        bfproxy.aabb.extents.setTo(hw,hh);
        bfproxy.isStatic = true;
        return bfproxy;
    }

}