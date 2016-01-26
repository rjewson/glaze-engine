
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
    public var sleepingProxies:Array<BFProxy>;

    public var map:Map;
    public var nf:Intersect;

    public function new(map:Map, nf:Intersect) {
        this.map = map;
        this.nf = nf;
        staticProxies  = new Array<BFProxy>();
        dynamicProxies = new Array<BFProxy>();
        sleepingProxies = new Array<BFProxy>();
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

        //Loop back over the proxies
        var i = dynamicProxies.length;
        while (--i>=0) {

            var dynamicProxy = dynamicProxies[i];

            //Has body (therefore is in control)
            if (dynamicProxy.body!=null) {
                if (!dynamicProxy.isSensor)
                    //First test against map
                    map.testCollision( dynamicProxy );
                //if it can sleep, sleep it
                if (dynamicProxy.body.canSleep) {
                    sleep(dynamicProxy);
                }
            }

            //Next test against all static proxies
            for (staticProxy in staticProxies) {
                nf.Collide(dynamicProxy,staticProxy);
            }

            //Now check against the sleepers
            var k = sleepingProxies.length;
            while (--k>=0) {
                var sleepingProxy = sleepingProxies[k];
                //its awake now?
                if (!sleepingProxy.body.canSleep) {
                    wake(sleepingProxy);
                } else {
                    nf.Collide(dynamicProxy,sleepingProxy);                    
                }
            }

            //Finally test against dynamic
            var j = i;
            while (--j>=0) {
                var dynamicProxyB = dynamicProxies[j];
                nf.Collide(dynamicProxy,dynamicProxyB);
            }

        }
    }

    public function QueryArea(aabb:glaze.geom.AABB,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true) {
        
        if (checkDynamic) {
            for (proxy in sleepingProxies) {
                if (!proxy.isSensor&&aabb.overlap(proxy.aabb)) 
                    result(proxy);
            }
            for (proxy in dynamicProxies) {
                if (!proxy.isSensor&&aabb.overlap(proxy.aabb)) 
                    result(proxy);
            }
        }

        if (checkStatic) {
            for (proxy in staticProxies) {
                if (!proxy.isSensor&&aabb.overlap(proxy.aabb))
                    result(proxy);
            }
        }

    }

    public function CastRay(ray:Ray,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true) {
        map.castRay(ray);
        if (checkDynamic) {
            for (proxy in sleepingProxies)
                if (!proxy.isSensor) 
                    nf.RayAABB(ray,proxy);
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

    public function wake(proxy:BFProxy) {
        sleepingProxies.remove(proxy);
        proxy.body.isSleeping = false;
        dynamicProxies.push(proxy);
        trace("wake:"+proxy.entity.id);
    }

    public function sleep(proxy:BFProxy) {
        dynamicProxies.remove(proxy);
        proxy.body.isSleeping = true;
        sleepingProxies.push(proxy);
        trace("sleep:"+proxy.entity.id);
    }

    public function dump() {
        trace("("+dynamicProxies.length+","+staticProxies.length+")");
    }



}