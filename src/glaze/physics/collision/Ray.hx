
package glaze.physics.collision;

import glaze.geom.Vector2;
import glaze.physics.collision.Contact;

class Ray 
{

    public var origin:Vector2 = new Vector2();
    public var target:Vector2 = new Vector2();
    public var range:Float = 0;

    public var delta:Vector2 = new Vector2();
    public var direction:Vector2 = new Vector2();

    public var contact:Contact = new Contact();

    public var hit:Bool;

    public var callback:BFProxy->Int;

    public function new() {

    }

    public function initalize(origin:Vector2,target:Vector2,range:Float,callback:BFProxy->Int) {
        reset();
        this.origin.copy(origin);
        this.target.copy(target);

        delta.copy(target);
        delta.minusEquals(origin);

        direction.copy(delta);
        direction.normalize();

        if (range<=0) {
            this.range = delta.length();
        } else {
            this.range = range;
            //scale the delta correctly now
            delta.copy(direction);
            delta.multEquals(range);
        }

        this.callback = callback;
    }

    public function reset() {
        contact.distance = 9999999999;
        hit = false;
    }

    public function report(distX:Float,distY:Float,normalX:Float,normalY:Float,proxy:BFProxy=null) {
        
        if (callback!=null&&proxy!=null) {
            if (callback(proxy)<0) {
                trace('filtered');
                return;
            }
        }

        var distSqrd = distX*distX+distY*distY;
        if (distSqrd<contact.distance*contact.distance) {
            contact.position.setTo(origin.x+distX,origin.y+distY);
            contact.normal.setTo(normalX,normalY);
            contact.distance = Math.sqrt(distSqrd);
            hit = true;
        } 

    }

}