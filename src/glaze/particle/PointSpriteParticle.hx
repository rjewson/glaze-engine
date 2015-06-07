
package glaze.particle;

import wgr.geom.Point;

class PointSpriteParticle
{

    public static inline var INV_ALPHA:Float = 1/255;
    
    public var pX:Float;
    public var pY:Float;

    public var vX:Float;
    public var vY:Float;
    
    public var fX:Float;
    public var fY:Float;
    
    public var type:Float;
    public var size:Float;

    public var externalForce:Point;
    
    public var age:Float;
    public var ttl:Float;
    public var damping:Float;
    
    public var decay:Float;
    public var colour:Float;
    public var alpha:Float;

    public var next:PointSpriteParticle;
    public var prev:PointSpriteParticle;

    public function new() 
    {
    }
    
    inline public function Initalize(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decay:Float, top:Bool, externalForce:Point, data1:Int, data2:Int, data3:Int,data4:Int) {
        this.pX = x;
        this.pY = y;
        this.vX = vX;
        this.vY = vY;
        this.fX = fX;
        this.fY = fY;
        this.ttl = ttl;
        this.age = ttl;
        this.damping = damping;
        this.decay = decay;
        this.externalForce = externalForce;
        this.type = data1;
        this.size = data2;
        this.colour = data3;
        this.alpha = untyped{ (this.colour & 0xFF) * INV_ALPHA; }
    }
    
    inline public function Update(deltaTime:Float,invDeltaTime:Float):Bool {
        vX += fX + externalForce.x;
        vY += fY + externalForce.y;
        vX *= damping;
        vY *= damping;
        pX += vX * invDeltaTime;
        pY += vY * invDeltaTime;
        age -= deltaTime;
        alpha -= decay;
        return age > 0;
    }
    
}