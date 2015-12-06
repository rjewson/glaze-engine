package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.physics.constraint.Spring;

class Held implements IComponent {

	public var holder:Entity;
	public var spring:Spring;

    public function new() {
    }

}