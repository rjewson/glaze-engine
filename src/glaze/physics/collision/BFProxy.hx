
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

    public var aabb:AABB;

    public var offset:Vector2;

    public var body:Body;
    public var entity:Entity;

    public var isStatic:Bool = false;
    public var isSensor:Bool = false;

    public var filter:Filter;

    public var contactCallbacks:Array<ContactCallback> = [];

    public function new() {
        aabb = new AABB();
        offset = new Vector2();
    }

    // public function new(width:Float,height:Float,filter:Filter,offsetX:Float=0,offsetY:Float=0,isSensor:Bool=false) {
    //     aabb = new AABB();
    //     aabb.extents.setTo(width,height);
    //     offset = new Vector2(offsetX,offsetY);
    //     this.filter = filter;
    // }

    public function setBody(body:Body) {
        this.body = body;
        this.aabb.position = body.position;
        isStatic = false; //bodies are always dynamic
    }

    public function collide(proxy:BFProxy,contact:Contact){
        for (callback in contactCallbacks)
            callback(this,proxy,contact);
    }

    public static inline function CreateStaticFeature(x:Float,y:Float,hw:Float,hh:Float,filter:Filter):BFProxy {
        var bfproxy = new BFProxy();//hw,hh,filter);
        bfproxy.aabb.extents.setTo(hw,hh);
        bfproxy.filter = filter;
        bfproxy.aabb.position.setTo(x,y);
        bfproxy.isStatic = true;
        return bfproxy;
    }

}