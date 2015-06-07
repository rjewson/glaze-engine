package glaze.physics.collision.broadphase;

interface IBroadphase {
    function addProxy(proxy:BFProxy):Void;
    function removeProxy(proxy:BFProxy):Void;
    function collide():Void;
    function QueryArea(aabb:glaze.geom.AABB,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true):Void;
    function CastRay(ray:Ray,result:BFProxy->Void,checkDynamic:Bool = true,checkStatic:Bool = true):Void;
    var staticProxies:Array<BFProxy>;
    var dynamicProxies:Array<BFProxy>;
}