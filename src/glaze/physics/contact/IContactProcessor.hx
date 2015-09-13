package glaze.physics.contact;

import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;

interface IContactProcessor {
	function callback(a:BFProxy,b:BFProxy,contact:Contact):Void;
}