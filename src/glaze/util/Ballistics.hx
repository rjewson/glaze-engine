package glaze.util;

import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.Body;

class Ballistics {

	public static function calcProjectileVelocity(body:Body,target:Vector2,velocity:Float) {
 		var vel = target.clone();
        vel.minusEquals(body.position);
        vel.normalize();
        vel.multEquals(velocity); 
        body.maxScalarVelocity = velocity;
        body.velocity.setTo(vel.x,vel.y);
	}

}