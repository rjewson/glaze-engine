package glaze.physics.collision.broadphase.uniformgrid;

import glaze.ds.Array2D;
import glaze.ds.DynamicObject;
import glaze.geom.Vector2;
import glaze.physics.collision.BFProxy;

class UniformGrid implements IBroadphase {

	public static inline var RIGHT:Int = 1;
	public static inline var DOWN:Int =  2;

    public var staticProxies:Array<BFProxy>;
    public var dynamicProxies:Array<BFProxy>;

    public var map:Map;
    public var nf:Intersect;

	public var grid:Array2D<Cell>;

	public var target:Vector2;

	public var pairs:Dynamic;
	public var step:Int;

    public function new(map:Map, nf:Intersect, worldGridWidth:Int, worldGridHeight:Int, cellSize:Int) {
    	this.map = map;
    	this.nf = nf;
    	this.target = new Vector2();

        staticProxies  = new Array<BFProxy>();
        dynamicProxies = new Array<BFProxy>();

		grid = new Array2D<Cell>(worldGridWidth, worldGridHeight, cellSize);
		
		pairs = {};
		step = 0;

		init();
	}

	function init():Void {
		var index = 0;
        for (y in 0...grid.gridWidth) {
            for (x in 0...grid.gridHeight) {
                grid.data.push( 
                	new Cell(
                		map,
                		nf,
                		index++,
                		new glaze.geom.Vector2(x,y),
                		new glaze.geom.AABB2(
                			y*grid.cellSize,
                			(x+1)*grid.cellSize,
                			(y+1)*grid.cellSize,
                			x*grid.cellSize
                		)
                	)
                );
            }
        }
        for (x in 0...grid.gridWidth) {
            for (y in 0...grid.gridHeight) {
                var cell = grid.getSafe(x, y);
                cell.adjacentRight = grid.getSafe(x+1, y);
                cell.adjacentDown = grid.getSafe(x, y+1);
                cell.adjacentRightDown = grid.getSafe(x+1,y+1);
            }
        }
        // js.Lib.debug();
	}    

    public function addProxy(proxy:BFProxy) {
    	hashProxy(proxy);

    	// var target = proxy.isStatic ? staticProxies : dynamicProxies;
     //    target.push(proxy);
    }

    public function removeProxy(proxy:BFProxy) {

		if (proxy.userData1>=0) {

			var oldCell = grid.data[proxy.userData1];
			oldCell.removeProxy(proxy);
			
			var oldRight = (proxy.userData2&RIGHT)>0;
			var oldDown = (proxy.userData2&DOWN)>0;

			if (oldRight&&oldCell.adjacentRight!=null) 
				oldCell.adjacentRight.removeProxy(proxy);

			if (oldDown&&oldCell.adjacentDown!=null)
				oldCell.adjacentDown.removeProxy(proxy);

			if (oldRight&&oldDown&&oldCell.adjacentRightDown!=null)
				oldCell.adjacentRightDown.removeProxy(proxy);
		}    	

        // var target = proxy.isStatic ? staticProxies : dynamicProxies;
        // target.remove(proxy);
    }

	public function collide() {
		step++;
		
		for (cell in grid.data) {
			var index = cell.dynamicProxies.length;
			while (--index>=0) {
				var proxy = cell.dynamicProxies[index];
				 if (proxy.userData1==cell.index)
					hashProxy(proxy);
			}
		}

		for (cell in grid.data) {
			// cell.collide();

	        var count = cell.dynamicProxies.length;
	        for (i in 0...count) {

	            var dynamicProxy = cell.dynamicProxies[i];

	            //First test against map
	            if (!dynamicProxy.isSensor&&dynamicProxy.body!=null&&dynamicProxy.userData1==cell.index)
	                map.testCollision( dynamicProxy );

	            //Next test against all static proxies
	            for (staticProxy in cell.staticProxies) {
	            	var hash = BFProxy.HashBodyIDs(staticProxy.id,dynamicProxy.id);
	            	if (untyped pairs[hash]!=step) {
	            		if (nf.Collide(dynamicProxy,staticProxy)) {
		            		untyped pairs[hash]=step;
	            		}
	            	} else {
	            		// trace("double");
	            	}
	            }

	            //Finally test against dynamic
	            for (j in i+1...count) {
	                var dynamicProxyB = cell.dynamicProxies[j];
	                nf.Collide(dynamicProxy,dynamicProxyB);
	            }

	        }


		}
	}

    public function QueryArea(aabb:glaze.geom.AABB,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true) {  

 		var startX = grid.Index(aabb.l);
        var startY = grid.Index(aabb.t);

        var endX = grid.Index(aabb.r) + 1;
        var endY = grid.Index(aabb.b) + 1;

        for (x in startX...endX) {
            for (y in startY...endY) { 
                var cell = grid.getSafe(x,y);

                if (cell==null) continue;

		        if (checkDynamic) {
		            for (proxy in cell.dynamicProxies) {
		                if (!proxy.isSensor&&aabb.overlap(proxy.aabb)) 
		                    result(proxy);
		            }
		        }

		        if (checkStatic) {
		            for (proxy in cell.staticProxies) {
		                if (!proxy.isSensor&&aabb.overlap(proxy.aabb))
		                    result(proxy);
		            }
		        }
		    }
		}
    }

    public function CastRay(ray:Ray,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true) {
    	
    	target.copy(ray.origin);
    	target.plusEquals(ray.delta);

        var startX = grid.Index(Math.min(ray.origin.x,target.x));
        var startY = grid.Index(Math.min(ray.origin.y,target.y));

        var endX = grid.Index(Math.max(ray.origin.x,target.x)) + 1;
        var endY = grid.Index(Math.max(ray.origin.y,target.y)) + 1;

        map.castRay(ray);

        for (x in startX...endX) {
            for (y in startY...endY) { 
                var cell = grid.getSafe(x,y);

                if (cell==null) continue;

		        if (checkDynamic) {
		            for (proxy in cell.dynamicProxies)
		                if (!proxy.isSensor) 
		                    nf.RayAABB(ray,proxy);
		        }

		        if (checkStatic) {
		            for (proxy in cell.staticProxies)
		                if (!proxy.isSensor)
		                    nf.RayAABB(ray,proxy);
		        }

		    }
		}
    }

    //TODO Hash swept AABB of proxies & ignore those that dont have bodies
    //TODO Implement sleep system
	function hashProxy(proxy:BFProxy) {

		var x = grid.Index(proxy.aabb.l);
		var y = grid.Index(proxy.aabb.t);
		var newCell = grid.get(x,y);

		var right = proxy.aabb.r > newCell.aabb2.r;
		var down  = proxy.aabb.b > newCell.aabb2.b;

		var occupancyHash = 0;
		if (right) occupancyHash |= RIGHT;
		if (down) occupancyHash  |= DOWN;

		//nothing changes?
		if (newCell.index==proxy.userData1 && occupancyHash==proxy.userData2) return;

		removeProxy(proxy);
		
		proxy.userData1 = newCell.index;
		proxy.userData2 = occupancyHash;

		newCell.addProxy(proxy);

		if (right)
			newCell.adjacentRight.addProxy(proxy);
		if (down)
			newCell.adjacentDown.addProxy(proxy);
		if (right&&down)
			newCell.adjacentRightDown.addProxy(proxy);

	}

	public function dump() {
		var result = [];
		var staticCount = 0;
		var dynamicCount = 0;
        for (y in 0...grid.gridHeight) {
        	var row = [];
			for (x in 0...grid.gridWidth) {
                var cell = grid.get(x, y);
                for (proxy in cell.dynamicProxies) 
                	if (proxy.userData1==cell.index) { 
                		dynamicCount++;
                		if (x==1&&y==1)
                			trace(proxy.entity.name);
                	}
                for (proxy in cell.staticProxies)
                	if (proxy.userData1==cell.index)
                		staticCount++;
                row.push(cell.dynamicProxies.length+","+cell.staticProxies.length);
                
                // staticCount+=cell.staticProxies.length;
                // dynamicCount+=cell.dynamicProxies.length;
            }
            result.push(row);
        }		
        untyped console.table(result);
        trace("("+dynamicCount+","+staticCount+")");
	}

}