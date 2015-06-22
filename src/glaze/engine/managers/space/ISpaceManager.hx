package glaze.engine.managers.space;

import glaze.eco.core.Entity;

interface ISpaceManager {
	function addEntity(entity:Entity):Void;
	function search(viewAABB:glaze.geom.AABB,callback:Entity->Bool->Void):Void;
}