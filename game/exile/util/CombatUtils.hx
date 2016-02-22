package exile.util;

import glaze.eco.core.Entity;
import glaze.engine.components.Destroy;
import glaze.engine.components.Health;
import glaze.geom.Vector2;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.util.BroadphaseAreaQuery;

class CombatUtils {

	public static var bfAreaQuery:glaze.util.BroadphaseAreaQuery;
	public static var broadphase:IBroadphase;

	public function new() {
		
	}

	public static function setBroadphase(bf:IBroadphase) {
		CombatUtils.broadphase = bf;
		CombatUtils.bfAreaQuery = new BroadphaseAreaQuery(bf);
	}

	public static function explode(position:Vector2,radius:Float,power:Float,ignoreEntity:Entity) {
	    CombatUtils.bfAreaQuery.query(position,radius,ignoreEntity,true);
	    var item = bfAreaQuery.entityCollection.entities.head;
        while (item!=null) {
            if (item.entity.getComponent(Destroy)==null) {

                var health = item.entity.getComponent(Health);
                var body = item.entity.getComponent(PhysicsBody);

                if (health!=null || body!=null) {
                    var effect = (radius/Math.sqrt(item.distance))*power;
                    // trace('e=$effect');
                    if (health!=null) {
                        health.applyDamage(effect);
                    }
                    
                    if (body!=null) {
                        var delta = body.body.position.clone();
                        delta.minusEquals(position);
                        delta.normalize();
                        delta.multEquals(effect);
                        body.body.addForce(delta);
                    }               
                }
            }
            item = item.next;
        }
	}

}