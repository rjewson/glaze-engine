package glaze.engine.managers.space;

import glaze.ds.Array2D;
import glaze.eco.core.Entity;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.engine.managers.space.SpaceManagerProxy;
import glaze.geom.Vector2;

class RegularGridSpaceManager implements ISpaceManager {
	
	public var grid:Array2D<Cell>;
    public var currentCells:Array<Cell>;
    public var count:Int = 1;
    public var lastUpdatePosition:Vector2;
    public var updateDistanceDelta:Float = 100*100;

	public function new(gridWidth:Int,gridHeight:Int,gridCellSize:Int) {  
		grid = new Array2D<Cell>(gridWidth,gridHeight,gridCellSize);
        currentCells = new Array<Cell>();

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

    public function addActiveCell(cell:Cell,viewAABB:glaze.geom.AABB,callback:Entity->Bool->Void) {
        for (proxy in cell.proxies) {
            if (proxy.referenceCount++==0) {
                callback(proxy.entity,true);
            }
        } 
        cell.updateCount = count;
    }

    public function removeActiveCell(cell:Cell,viewAABB:glaze.geom.AABB,callback:Entity->Bool->Void) {
        for (proxy in cell.proxies) {
            if (--proxy.referenceCount==0) {
                callback(proxy.entity,false);
            }
        }
        //Reset the update count
        cell.updateCount = 0;
    }

	public function search(viewAABB:glaze.geom.AABB,callback:Entity->Bool->Void) {

        if (lastUpdatePosition==null) {
            lastUpdatePosition = viewAABB.position.clone();
        } else {
            if (lastUpdatePosition.distSqrd(viewAABB.position) < updateDistanceDelta)
                return;
            lastUpdatePosition.copy(viewAABB.position);
        }
		var startX = grid.Index(viewAABB.position.x - viewAABB.extents.x);
        var startY = grid.Index(viewAABB.position.y - viewAABB.extents.y);

        var endX = grid.Index(viewAABB.position.x + viewAABB.extents.x) + 1;
        var endY = grid.Index(viewAABB.position.y + viewAABB.extents.y) + 1;

        for (x in startX...endX) {
            for (y in startY...endY) {
                var cell = grid.get(x,y);
                //Out of bounds, skip
                if (cell==null)
                    continue;

                if (cell.updateCount==0)
                    currentCells.push(cell);
                else 
                    cell.updateCount=count;
            }
        }

        var i = currentCells.length;
        while (i-->0) {
            var cell = currentCells[i];
            if (cell.updateCount==0) {
                addActiveCell(cell,viewAABB,callback);
            } else if (cell.updateCount<count) {
                removeActiveCell(cell,viewAABB,callback);
                currentCells.splice(i,1);
            }
        }

        count++;
	}

}

class Cell {

	public var proxies:Array<SpaceManagerProxy>;
    public var updateCount:Int;

	public function new() {
	    proxies = new Array<SpaceManagerProxy>();
        updateCount = 0;
	}
}