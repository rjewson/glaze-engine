package glaze.physics.constraint;

import glaze.physics.Body;
import glaze.geom.Vector2;

class Spring extends Constraint
{

	public var stiffness : Float;
	var restLength : Float;
	var breakDelta : Float;
	
	public function new(body1:Body, position1:Vector2, offset1:Vector2, body2:Body, position2:Vector2, offset2:Vector2, stiffness:Float = 0.5, breakDelta:Float = 0.1) 
	{
		super();
		this.breakDelta = breakDelta;
		this.body1 = body1;
		this.position1 = position1;
		this.offset1 = offset1;
		this.body2 = body2;
		this.position2 = position2;
		this.offset2 = offset2;
		this.stiffness = stiffness;
		restLength = length();		
	}

	override public function resolve() : Bool {
		// if ((!body1 || !body1.active || !body2 || !body2.active) ) return false;

		// var deltaLength : Float = length + 0.00001;
		//trace(body1.position + "-" + offset1);
		var dX : Float = (position1.x+offset1.x) - (position2.x+offset2.x);
		var dY : Float = (position1.y+offset1.y) - (position2.y+offset2.y);
		var deltaLength : Float = Math.sqrt(dX * dX + dY * dY) + 0.00001;
		
		// if (deltaLength-restLength >= breakDelta) {
		// 	trace(offset1);
		// 	trace("Break "+deltaLength+" "+breakDelta);
		// 	remove = true;
		// 	return false;
		// }
		var mass1 = body1!=null?body1.invMass:0;
		var mass2 = body2!=null?body2.invMass:0;
		var diff : Float = (deltaLength - restLength) / (deltaLength * (mass1 + mass2));
		// var delta : Vector2 = p1.pos.minus(p2.pos);
		// var dmds : Vector2 = delta.mult(diff * stiffness);
		var factor : Float = diff * stiffness;
		// dX,dY is now dmds
		dX *= factor;
		dY *= factor;

		// if (!p1.fixed) p1.pos.minusEquals(dmds.mult(p1.invMass));
		if (body1!=null) {
			body1.position.x -= dX * body1.invMass;
			body1.position.y -= dY * body1.invMass;
		}
		// if (!p2.fixed) p2.pos.plusEquals(dmds.mult(p2.invMass));
		if (body2!=null) {
			body2.position.x += dX * body2.invMass;
			body2.position.y += dY * body2.invMass;
		}
		return true;
	}

	public function length() : Float {
		var x = position1.x+offset1.x-position2.x+offset2.x;
		var y = position1.y+offset1.y-position2.y+offset2.y;
		return Math.sqrt(x*x+y*y);
		// return body1.position.plus(offset1).distance(body2.position.plus(offset2));
		//return body1.position.distance(body2.position);
	}

	public function SetLength(len : Float) : Void {
		restLength = len;
	}
	
}