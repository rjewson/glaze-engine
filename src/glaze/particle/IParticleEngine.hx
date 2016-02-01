package glaze.particle;

import glaze.geom.Vector2;

interface IParticleEngine 
{
    function Update():Void;
    function EmitParticle(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decayable:Bool, top:Bool, externalForce:Vector2, data1:Int, data2:Int, data3:Int,data4:Int,data5:Int):Bool;
}