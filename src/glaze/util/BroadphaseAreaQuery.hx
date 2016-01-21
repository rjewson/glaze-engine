package glaze.util;

import glaze.ds.EntityCollection;
import glaze.eco.core.Entity;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Ray;

class BroadphaseAreaQuery {

	var broadphase:IBroadphase;
	var ray:Ray;
	public var entityCollection:EntityCollection;
	var aabb:glaze.geom.AABB;
	// var filterEntity:Entity;

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
        // this.filterEntity = filterOwner;

        function addBroadphaseItem(bfproxy:BFProxy) {

            if (filterEntity!=null&&bfproxy.entity==filterEntity)
                return;
			
			if (visibleCheck) {
				ray.initalize(position,bfproxy.entity.getComponent(Position).coords,0,null);
				//js.Lib.debug();
				broadphase.CastRay(ray,null,false,false); //Dont check ray against static and dynamic items
				if (ray.hit)
					return;
           }

            var item = entityCollection.addItem(bfproxy.entity);
            item.distance = bfproxy.aabb.position.distSqrd(aabb.position);
            item.perspective = aabb.position;
        }

        broadphase.QueryArea(aabb,addBroadphaseItem,true,true); //Check static and dynamic items

	}

}