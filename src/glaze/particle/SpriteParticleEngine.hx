
package glaze.particle;

import wgr.display.DisplayObjectContainer;
import wgr.display.Sprite;
import wgr.geom.Point;
import wgr.particle.SpriteParticle;

class SpriteParticleEngine
{
    public var particleCount:Int;
    public var deltaTime:Float;
    public var invDeltaTime:Float;
    public var activeParticles:Sprite;
    public var cachedParticles:Sprite;
    
    public var canvas:DisplayObjectContainer;
    
    public function new(particleCount:Int, deltaTime:Float) 
    {
        this.particleCount = particleCount;
        this.deltaTime = deltaTime;
        this.invDeltaTime = deltaTime / 1000;
        canvas = new DisplayObjectContainer();
        canvas.id = "ParticleEngine";
        for (i in 0...particleCount) {
            var p = new SpriteParticle();
            p.next = cachedParticles;
            cachedParticles = cast p;
        }       
    }
    
    inline public function EmitParticle(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decayable:Bool, top:Bool, externalForce:Point, type:Int, data1:Int, data2:Int):Bool {
        if (cachedParticles == null)
            return false;
            
        var particle = cachedParticles;
        cachedParticles = cachedParticles.nextSprite;
        
        if (activeParticles == null) {
            activeParticles = particle;
            particle.nextSprite = particle.prevSprite = null;
        } else {
            particle.nextSprite = activeParticles;
            particle.prevSprite = null;
            activeParticles.prevSprite = particle;
            activeParticles = particle;
        }
        
        cast(particle,SpriteParticle).Initalize(x, y, vX, vY, fX, fY, ttl, damping, decayable ? deltaTime/ttl : 0, top, externalForce, type, data1, data2);
        
        canvas.addChild(particle);
        
        return true;
    }
        
    public function Update():Void {

        var particle = activeParticles;
        while (particle != null) {
            if (!cast(particle,SpriteParticle).Update(deltaTime,invDeltaTime)) {
                var next:Sprite = particle.nextSprite;
                if (particle.prevSprite == null) {
                    activeParticles =  particle.nextSprite;
                } else {
                    particle.prevSprite.nextSprite = particle.nextSprite;
                }
                if (particle.nextSprite != null) {
                    particle.nextSprite.prevSprite = particle.prevSprite;
                }
                particle.nextSprite = cachedParticles;
                cachedParticles = particle;
                
                canvas.removeChild(particle);
                
                particle = next;
            } else {
                particle = particle.nextSprite;
            }
        }
    }
    
}