package glaze.physics.collision.broadphase.uniformgrid;

import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Intersect;
import glaze.physics.collision.Map;
import glaze.geom.Vector2;

class Cell {

	public var staticProxies:Array<BFProxy>;
    public var dynamicProxies:Array<BFProxy>;
    public var map:Map;
    public var nf:Intersect;

    public var index:Int;
    public var coords:Vector2;
    public var aabb2:glaze.geom.AABB2;

    public var adjacentRight:Cell;
    public var adjacentDown:Cell;
    public var adjacentRightDown:Cell;

    public function new(map:Map, nf:Intersect, index:Int, coords:Vector2, aabb2:glaze.geom.AABB2) {
        this.map = map;
        this.nf = nf;

        this.index = index;
    	this.coords = coords;
    	this.aabb2 = aabb2;

        staticProxies  = new Array<BFProxy>();
        dynamicProxies = new Array<BFProxy>();
    }

    public function addProxy(proxy:BFProxy) {
        var target = proxy.isStatic ? staticProxies : dynamicProxies;
        target.push(proxy);
    }

    public function removeProxy(proxy:BFProxy):Bool {
        var target = proxy.isStatic ? staticProxies : dynamicProxies;
        return target.remove(proxy);
    }

    public function collide() {
        var count = dynamicProxies.length;
        for (i in 0...count) {

            var dynamicProxy = dynamicProxies[i];

            //First test against map
            if (!dynamicProxy.isSensor&&dynamicProxy.body!=null)
                map.testCollision( dynamicProxy );

            //Next test against all static proxies
            for (staticProxy in staticProxies) {
                nf.Collide(dynamicProxy,staticProxy);
            }

            //Finally test against dynamic
            for (j in i+1...count) {
                var dynamicProxyB = dynamicProxies[j];
                nf.Collide(dynamicProxy,dynamicProxyB);
            }

        }
    }

}