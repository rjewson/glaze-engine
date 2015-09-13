package glaze.physics.contact;

import glaze.geom.Vector2;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.contact.IContactProcessor;

class ForceGenerator implements IContactProcessor {

	public function new() {
	    
	}

	public function callback(a:BFProxy,b:BFProxy,contact:Contact) {
		var area = a.aabb.overlapArea(b.aabb);
		b.body.damping = 0.90;
        b.body.addForce(new Vector2(0,-area/50));
	}

}