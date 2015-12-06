package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class EnvironmentForce implements IComponent {

	public var direction:Vector2;

    public function new(direction:Vector2) {
    	this.direction = direction;
    }

}