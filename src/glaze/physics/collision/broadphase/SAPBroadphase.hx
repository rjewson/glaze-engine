
package glaze.physics.collision.broadphase;

import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Intersect;
import glaze.physics.collision.Map;
import glaze.geom.Vector2;

class SAPBroadphase implements IBroadphase
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
        if (proxy.isStatic)
            sort(target);
    }

    public function removeProxy(proxy:BFProxy) {
        var target = proxy.isStatic ? staticProxies : dynamicProxies;
        target.remove(proxy);
    }

    public function collide() {

        sort(dynamicProxies);

    // for(var i=0, N=bodies.length|0; i!==N; i++){
    //     var bi = bodies[i];

    //     for(var j=i+1; j<N; j++){
    //         var bj = bodies[j];

    //         // Bounds overlap?
    //         var overlaps = (bj.aabb.lowerBound[axisIndex] <= bi.aabb.upperBound[axisIndex]);
    //         if(!overlaps){
    //             break;
    //         }

    //         if(Broadphase.canCollide(bi,bj) && this.boundingVolumeCheck(bi,bj)){
    //             result.push(bi,bj);
    //         }
    //     }
    // }


        var count = dynamicProxies.length;
        var staticProxyStart = 0;
        var tollerance = 30;

        for (i in 0...count) {

            var dynamicProxy = dynamicProxies[i];

            //First test against map
            if (!dynamicProxy.isSensor&&dynamicProxy.body!=null)
                map.testCollision( dynamicProxy );

            //Next test against all static proxies
            while (staticProxyStart<staticProxies.length) {
                if (staticProxies[staticProxyStart].aabb.r<=dynamicProxy.aabb.l-tollerance) {
                    staticProxyStart++;
                } else {
                    break;
                }
            }

            for (k in staticProxyStart...staticProxies.length) {
                var staticProxy = staticProxies[k];
                if (dynamicProxy.aabb.l-tollerance<=staticProxy.aabb.r+tollerance) {
                    nf.Collide(dynamicProxy,staticProxy);                     
                } else {
                    break;
                }
            }

            //Finally test against dynamic
            for (j in i+1...count) {
                var dynamicProxyB = dynamicProxies[j];
                if (dynamicProxy.aabb.l-tollerance<=dynamicProxyB.aabb.r+tollerance) {
                    nf.Collide(dynamicProxy,dynamicProxyB);                     
                } else {
                    break;
                }
            }

        }
    }

    public function QueryArea(aabb:glaze.geom.AABB,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true) {
        
        if (checkDynamic) {
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

    public function sort(list:Array<BFProxy>) {

        // js.Lib.debug();
        var i = 1;
        var l = list.length;

        while (i<l) {
        // for(var i=1,l=list.length; i<l; i++) {

            var v = list[i];
            var j = i-1;
            while (j>=0) {
            // for(var j=i - 1;j>=0;j--) {
                if(list[j].aabb.l <= v.aabb.l) {
                    break;
                }
                list[j+1] = list[j];
                j--;
            }
            list[j+1] = v;
            i++;
        }
    }

    public function dump() {
        trace("("+dynamicProxies.length+","+staticProxies.length+")");
    }



}