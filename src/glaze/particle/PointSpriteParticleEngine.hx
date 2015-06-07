
package glaze.particle;

import wgr.geom.Point;
import wgr.particle.PointSpriteParticle;
import wgr.renderers.webgl.PointSpriteLightMapRenderer;
import wgr.renderers.webgl.PointSpriteRenderer;

class PointSpriteParticleEngine implements IParticleEngine
{
    public var particleCount:Int;
    public var deltaTime:Float;
    public var invDeltaTime:Float;
    public var activeParticles:PointSpriteParticle;
    public var cachedParticles:PointSpriteParticle;
        
    public var renderer:PointSpriteRenderer;
    public var ZERO_FORCE:Point;

    public function new(particleCount:Int, deltaTime:Float) 
    {
        this.particleCount = particleCount;
        this.deltaTime = deltaTime;
        this.invDeltaTime = deltaTime / 1000;
        ZERO_FORCE = new Point();
        for (i in 0...particleCount) {
            var p = new PointSpriteParticle();
            p.next = cachedParticles;
            cachedParticles = p;
        }
        this.renderer = new PointSpriteRenderer();
        this.renderer.ResizeBatch(particleCount);
    }
    
    public function EmitParticle(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decayable:Bool, top:Bool, externalForce:Point, data1:Int, data2:Int, data3:Int,data4:Int,data5:Int):Bool {
        if (cachedParticles == null)
            return false;
            
        var particle = cachedParticles;
        cachedParticles = cachedParticles.next;
        
        if (activeParticles == null) {
            activeParticles = particle;
            particle.next = particle.prev = null;
        } else {
            particle.next = activeParticles;
            particle.prev = null;
            activeParticles.prev = particle;
            activeParticles = particle;
        }
        
        particle.Initalize(x, y, vX, vY, fX, fY, ttl, damping, decayable ? deltaTime/ttl : 0, top, externalForce!=null?externalForce:ZERO_FORCE, data1, data2, data3, data4);

        return true;
    }
        
    public function Update():Void {
        renderer.ResetBatch();
        var particle = activeParticles;
        while (particle != null) {
            if (!particle.Update(deltaTime,invDeltaTime)) {
                var next = particle.next;
                if (particle.prev == null) {
                    activeParticles =  particle.next;
                } else {
                    particle.prev.next = particle.next;
                }
                if (particle.next != null) {
                    particle.next.prev = particle.prev;
                }
                particle.next = cachedParticles;
                cachedParticles = particle;
                                
                particle = next;
            } else {
                renderer.AddSpriteToBatch(Std.int(particle.type),particle.pX,particle.pY,particle.size,Std.int(particle.alpha*255),0xFF,0xFF,0xFF);
                particle = particle.next;
            }
        }
    }
    
}