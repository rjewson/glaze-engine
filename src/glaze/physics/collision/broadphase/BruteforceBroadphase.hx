
package glaze.physics.collision.broadphase;

import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Intersect;
import glaze.physics.collision.Map;
import glaze.geom.Vector2;

class BruteforceBroadphase implements IBroadphase
{

    public var staticProxies:Array<BFProxy>;
    public var dynamicProxies:Array<BFProxy>;
    public var map:Map;
    public var nf:Intersect;

    public function new(map:Map, nf:Intersect) {
        this.map = map;
        this.nf = nf;
        staticProxies  = new Array<BFProxy>();
        dynamicProxies = new Array<BFProxy>();
    }

    public function addProxy(proxy:BFProxy) {
        var target = proxy.isStatic ? staticProxies : dynamicProxies;
        target.push(proxy);
    }

    public function removeProxy(proxy:BFProxy) {
        var target = proxy.isStatic ? staticProxies : dynamicProxies;
        target.remove(proxy);
    }

    public function collide() {
        var count = dynamicProxies.length;
        for (i in 0...count) {

            var dynamicProxy = dynamicProxies[i];

            //First test against map
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

    public function QueryArea(aabb:glaze.geom.AABB,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true) {
        
        if (checkDynamic) {
            for (proxy in staticProxies) {
                if (!proxy.isSensor&&aabb.overlap(proxy.aabb)) 
                    result(proxy);
            }
        }

        if (checkStatic) {
            for (proxy in dynamicProxies) {
                if (!proxy.isSensor&&aabb.overlap(proxy.aabb))
                    result(proxy);
            }
        }

    }

    public function CastRay(ray:Ray,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true) {
        map.castRay(ray);
        if (checkDynamic) {
            for (proxy in dynamicProxies)
                if (!proxy.isSensor) 
                    nf.RayAABB(ray,proxy);
        }

        if (checkStatic) {
            for (proxy in staticProxies)
                if (!proxy.isSensor)
                    nf.RayAABB(ray,proxy);
        }

    }

}