package glaze.physics.constraint;

import glaze.physics.Body;
import glaze.geom.Vector2;

class Constraint 
{

	public var body1 : Body;
	public var position1 : Vector2;
	public var offset1 : Vector2;
	public var body2 : Body;
	public var position2 : Vector2;
	public var offset2 : Vector2;
	public var remove : Bool;
	
	public var destroyCallback :  Constraint -> Void;
	
	public function new() {	
	}

	public function resolve():Bool {
		return false;
	}
	
	public function Destroy():Void {
		if (destroyCallback != null)
			destroyCallback(this);
		// body1.RemoveConstraint(this);
		// body2.RemoveConstraint(this);
	}
	
}