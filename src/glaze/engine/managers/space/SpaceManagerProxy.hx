package glaze.engine.managers.space;

import glaze.eco.core.Entity;

class SpaceManagerProxy {
	
	public var aabb:glaze.geom.AABB = new glaze.geom.AABB();
	public var isStatic:Bool = false;
	public var entity:Entity = null;
	public var active:Bool = false;

	public function new() {
	}

}