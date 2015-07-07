package glaze.engine.actions;

import glaze.ds.EntityCollectionItem;
import glaze.eco.core.Engine;
import glaze.engine.components.Position;
import glaze.physics.systems.PhysicsCollisionSystem;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Ray;

class FilterSupport {

    var broadphase:IBroadphase;
    var ray:Ray;

	public function new(engine:Engine) {
		broadphase = engine.getSystem(PhysicsCollisionSystem).broadphase;
		ray = new Ray();
	}

	public function FilterVisibleAgainstMap(eci:EntityCollectionItem):Bool {
		// js.Lib.debug();
		ray.initalize(eci.perspective,eci.entity.getComponent(Position).coords,0,null);
		broadphase.CastRay(ray,null,false,false);
		return !ray.hit;
	}

}