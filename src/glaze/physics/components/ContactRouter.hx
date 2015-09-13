package glaze.physics.components;

import glaze.eco.core.IComponent;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.BFProxy.ContactCallback;
import glaze.physics.collision.Contact;
import glaze.physics.contact.IContactProcessor;

class ContactRouter implements IComponent {

	public var contactProcessors:Array<IContactProcessor>;

	public function new(contactProcessors:Array<IContactProcessor>) {
		this.contactProcessors = contactProcessors;
	}

	public function calback(a:BFProxy,b:BFProxy,contact:Contact) {
		for (processor in contactProcessors) {
			processor.callback(a,b,contact);
		}

	}

}