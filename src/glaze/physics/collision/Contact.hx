
package glaze.physics.collision;

import glaze.geom.Vector2;

class Contact 
{

    public var position:Vector2 = new Vector2();
    public var delta:Vector2    = new Vector2();
    public var normal:Vector2   = new Vector2();
    public var distance:Float   = 0;
    public var time:Float       = 0;
    public var sweepPosition:Vector2 = new Vector2();

    public function new() {

    }

    public function setTo(contact:Contact) {
        this.position.x = contact.position.x;
        this.position.y = contact.position.y;
        this.delta.x = contact.delta.x;
        this.delta.y = contact.delta.y;
        this.normal.x = contact.normal.x;
        this.normal.y = contact.normal.y;
        this.time = contact.time;
        this.distance = contact.distance;
        this.sweepPosition.x = contact.sweepPosition.x;
        this.sweepPosition.y = contact.sweepPosition.y;
    }

}