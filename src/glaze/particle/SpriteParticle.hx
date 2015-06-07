
package glaze.particle;

import wgr.display.Sprite;
import wgr.geom.Point;

class SpriteParticle extends Sprite
{

    public static var ZERO_FORCE:Point = new Point();
        
    public var vX:Float;
    public var vY:Float;
    
    public var fX:Float;
    public var fY:Float;
    
    public var externalForce:Point;
    
    public var age:Float;
    public var ttl:Float;
    public var damping:Float;
    
    public var decay:Float;
    
    public function new() 
    {
        super();
    }
    
    inline public function Initalize(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decay:Float, top:Bool, externalForce:Point, data1:Int, data2:Int, data3:Int,data4:Int) {
        position.x = x;
        position.y = y;
        this.vX = vX;
        this.vY = vY;
        this.fX = fX;
        this.fY = fY;
        this.ttl = ttl;
        this.age = ttl;
        this.damping = damping;
        this.decay = decay;
        this.externalForce = externalForce != null ? externalForce : ZERO_FORCE;
        alpha = 1;
    }
    
    inline public function Update(deltaTime:Float,invDeltaTime:Float):Bool {
        vX += fX + externalForce.x;
        vY += fY + externalForce.y;
        vX *= damping;
        vY *= damping;
        position.x += vX * invDeltaTime;
        position.y += vY * invDeltaTime;
        age -= deltaTime;
        alpha -= decay;
        return age > 0;
    }
    
}