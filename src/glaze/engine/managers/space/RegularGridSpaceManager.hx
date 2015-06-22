package glaze.engine.managers.space;

import glaze.ds.Array2D;
import glaze.eco.core.Entity;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.engine.managers.space.SpaceManagerProxy;

class RegularGridSpaceManager implements ISpaceManager {
	
	public var grid:Array2D<Cell>;

	public function new(gridWidth:Int,gridHeight:Int,gridCellSize:Int) {  
		grid = new Array2D<Cell>(gridWidth,gridHeight,gridCellSize);
		for (y in 0...grid.gridWidth) {
            for (x in 0...grid.gridHeight) {
                grid.data.push(new Cell());
            }
        }
	}

	public function addEntity(entity:Entity) {
		var proxy = new SpaceManagerProxy();
		proxy.aabb.position = entity.getComponent(Position).coords;
		proxy.aabb.extents = entity.getComponent(Extents).halfWidths;
		proxy.isStatic = true;
		proxy.entity = entity;
		hashProxy(proxy);
	}

	public function hashProxy(proxy:SpaceManagerProxy) {
		var startX = grid.Index(proxy.aabb.position.x - proxy.aabb.extents.x);
        var startY = grid.Index(proxy.aabb.position.y - proxy.aabb.extents.y);

        var endX = grid.Index(proxy.aabb.position.x + proxy.aabb.extents.x) + 1;
        var endY = grid.Index(proxy.aabb.position.y + proxy.aabb.extents.y) + 1;

        for (x in startX...endX) {
            for (y in startY...endY) {
                var cell = grid.get(x,y);
                trace("added to:",x,y);
                cell.proxies.push(proxy);
            }
        }
	}

	public function search(viewAABB:glaze.geom.AABB,callback:Entity->Bool->Void) {
		var startX = grid.Index(viewAABB.position.x - viewAABB.extents.x);
        var startY = grid.Index(viewAABB.position.y - viewAABB.extents.y);

        var endX = grid.Index(viewAABB.position.x + viewAABB.extents.x) + 1;
        var endY = grid.Index(viewAABB.position.y + viewAABB.extents.y) + 1;

        for (x in startX...endX) {
            for (y in startY...endY) {
                var cell = grid.get(x,y);
                for (proxy in cell.proxies) {
                	var overlap = proxy.aabb.overlap(viewAABB);
                	if (overlap) {
                		if (!proxy.active) {
                			callback(proxy.entity,true);
                			proxy.active=true;
                		}
                	} else {
                		if (proxy.active) {
                			callback(proxy.entity,false);
                			proxy.active=false;
                		}
                	}
                }
            }
        }		
	}

}

class Cell {

	public var proxies:Array<SpaceManagerProxy>;

	public function new() {
	    proxies = new Array<SpaceManagerProxy>();
	}
}