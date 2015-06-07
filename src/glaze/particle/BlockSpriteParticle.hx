package glaze.particle;

import glaze.geom.Vector2;

class BlockSpriteParticle
{

    public static inline var INV_ALPHA:Float = 1/255;
    
    public var pX:Float;
    public var pY:Float;

    public var vX:Float;
    public var vY:Float;
    
    public var fX:Float;
    public var fY:Float;
    
    public var externalForce:Vector2;
    
    public var age:Float;
    public var ttl:Float;
    public var damping:Float;
    
    public var decay:Float;

    public var size:Int;    
    public var alpha:Float;
    public var red:Int;
    public var green:Int;
    public var blue:Int;

    public var next:BlockSpriteParticle;
    public var prev:BlockSpriteParticle;

    public var alphaPerUpdate:Float;

    public function new() 
    {
    }
    
    inline public function Initalize(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decay:Float, top:Bool, externalForce:Vector2, data1:Int, data2:Int, data3:Int,data4:Int,data5:Int) {
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
        this.size = data1;
        this.alpha = untyped{ data2 * INV_ALPHA; }
        this.red = data3;
        this.green = data4;
        this.blue = data5;
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
        //trace(decay);
        return age > 0;
    }
    
}