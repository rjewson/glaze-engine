
package glaze.physics.collision;

import glaze.eco.core.Entity;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.geom.AABB;
import glaze.geom.Vector2;
import glaze.physics.Body;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.collision.Filter;

typedef ContactCallback = BFProxy -> BFProxy -> Contact -> Void;

class BFProxy 
{

    public var id:Int;
    public static var nextID:Int = 0;

    public var aabb:AABB;

    public var offset:Vector2;
    public var responseBias:Vector2;

    public var body:Body;
    public var entity:Entity;

    public var isStatic:Bool = false;
    public var isSensor:Bool = false;
    public var isActive:Bool = true;
    public var limitToStaticCheck:Bool = false;

    public var filter:Filter;

    public var userData1:Int = -1;
    public var userData2:Int = -1;

    public var contactCallbacks:Array<ContactCallback> = [];

    public function new() {
        aabb = new AABB();
        offset = new Vector2();
        responseBias = new Vector2(1,1);
        id = nextID++;
    }

    public function setBody(body:Body) {
        this.body = body;
        this.aabb.position = body.position;
        isStatic = false; //bodies are always dynamic
    }

    public function collide(proxy:BFProxy,contact:Contact){
        for (callback in contactCallbacks)
            callback(this,proxy,contact);
    }

    // public static inline function CreateStaticFeature(x:Float,y:Float,hw:Float,hh:Float,filter:Filter):BFProxy {
    //     var bfproxy = new BFProxy();
    //     bfproxy.aabb.extents.setTo(hw,hh);
    //     bfproxy.filter = filter;
    //     bfproxy.aabb.position.setTo(x,y);
    //     bfproxy.isStatic = true;
    //     return bfproxy;
    // }

    inline public static function HashBodyIDs(a:Int, b:Int):Int {
        return (a < b) ? (a << 16) | b : (b << 16) | a;
    }

}