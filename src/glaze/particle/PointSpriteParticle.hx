
package glaze.particle;

import glaze.geom.Vector2;
import glaze.particle.SpriteParticleSequence;

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
    public var sequence:SpriteParticleSequence;
    public var currentFrame:Int;
    public var msPerInc:Float;
    public var currentInc:Float;

    public var externalForce:Vector2;
    
    public var age:Float;
    public var ttl:Float;
    public var damping:Float;
    
    public var decay:Float;
    public var colour:Float;
    public var flipX:Int;
    public var flipY:Int;
    public var alpha:Float;

    public var next:PointSpriteParticle;
    public var prev:PointSpriteParticle;

    public function new() 
    {
    }
    
    inline public function Initalize(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decay:Float, top:Bool, externalForce:Vector2, sequence:SpriteParticleSequence, data2:Int, data3:Int,data4:Int,data5:Int) {
        this.pX = x;
        this.pY = y;
        this.vX = vX;
        this.vY = vY;
        this.fX = fX;
        this.fY = fY;
        this.ttl = sequence.ttl();
        this.age = 0;
        this.damping = damping;
        this.decay = decay;
        this.externalForce = externalForce;
        this.sequence = sequence;
        this.currentFrame = 0;
        this.currentInc = 0;
        this.msPerInc = this.ttl/sequence.len;
        this.size = data2;
        this.flipX = data3;
        this.flipY = data4;
        this.colour = 0;//data3;
        //this.alpha = untyped{ (this.colour & 0xFF) * INV_ALPHA; }
    }
/*    
10 frames 
5 fps
2000 ms
*/
    inline public function Update(deltaTime:Float,invDeltaTime:Float):Bool {
        vX += fX + externalForce.x;
        vY += fY + externalForce.y;
        vX *= damping;
        vY *= damping;
        pX += vX * invDeltaTime;
        pY += vY * invDeltaTime;
        age += deltaTime;
        alpha = 1;
        currentInc += deltaTime;
        if (currentInc>=msPerInc) {
            currentFrame++;
            currentInc = 0;
        }
        // currentFrame++;// = (1/60) * sequence.fps;
        // if (currentFrame>8) currentFrame=0;
        return age < ttl;
    }
    
}