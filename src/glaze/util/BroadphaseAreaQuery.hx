package glaze.util;

import glaze.ds.EntityCollection;
import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Ray;

class BroadphaseAreaQuery {

	public static inline var RAYCAST_THRESHOLD:Float = 10;

	var broadphase:IBroadphase;
	var ray:Ray;
	public var entityCollection:EntityCollection;
	var aabb:glaze.geom.AABB;
	var filterEntity:Entity;
	var visibleCheck:Bool;

	public function new(broadphase:IBroadphase) {
		this.broadphase = broadphase;
	    entityCollection = new EntityCollection();
	    aabb = new glaze.geom.AABB();
	    ray = new Ray();
	}

	public function query(position:Vector2,range:Float,filterEntity:Entity,visibleCheck:Bool) {
		// js.Lib.debug();
		entityCollection.clear();
		
		aabb.position.copy(position);
        aabb.extents.setTo(range,range);
        this.filterEntity = filterEntity;
        this.visibleCheck = visibleCheck;

        broadphase.QueryArea(aabb,addBroadphaseItem,true,true); //Check static and dynamic items
	}

	function addBroadphaseItem(bfproxy:BFProxy) {

        if (filterEntity!=null&&bfproxy.entity==filterEntity)
            return;
		
        var distance = bfproxy.aabb.position.distSqrd(aabb.position);

		if (distance>RAYCAST_THRESHOLD && visibleCheck) {
			ray.initalize(aabb.position,bfproxy.entity.getComponent(Position).coords,0,null);
			//js.Lib.debug();
			broadphase.CastRay(ray,null,false,false); //Dont check ray against static and dynamic items
			if (ray.hit)
				return;
       }

        var item = entityCollection.addItem(bfproxy.entity);
        item.distance = distance;
        item.perspective = aabb.position;
    }


}