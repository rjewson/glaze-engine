package glaze.particle;

import glaze.ds.Bytes2D;
import glaze.geom.Vector2;
import glaze.particle.PointSpriteParticle;
import glaze.particle.SpriteParticleManager;
import glaze.render.renderers.webgl.PointSpriteRenderer;

/*
 * Renders point sprites with textures
 */

class PointSpriteParticleEngine implements IParticleEngine
{
    public var particleCount:Int;
    public var deltaTime:Float;
    public var invDeltaTime:Float;
    public var activeParticles:PointSpriteParticle;
    public var cachedParticles:PointSpriteParticle;
        
    public var renderer:PointSpriteRenderer;
    public var ZERO_FORCE:Vector2;

    public var map:Bytes2D;

    public var spriteParticleManager:SpriteParticleManager;

    public function new(particleCount:Int, deltaTime:Float,spriteParticleManager:SpriteParticleManager,map:Bytes2D) 
    {
        this.particleCount = particleCount;
        this.deltaTime = deltaTime;
        this.invDeltaTime = deltaTime / 1000;
        this.spriteParticleManager = spriteParticleManager;
        this.map = map;
        ZERO_FORCE = new Vector2();
        for (i in 0...particleCount) {
            var p = new PointSpriteParticle();
            p.next = cachedParticles;
            cachedParticles = p;
        }
        this.renderer = new PointSpriteRenderer(particleCount);
    }
    
    public function EmitParticle(x:Float, y:Float, vX:Float, vY:Float, fX:Float, fY:Float, ttl:Int, damping:Float, decayable:Bool, top:Bool, externalForce:Vector2, data1:Int, data2:Int, data3:Int,data4:Int,data5:Int):Bool {
        if (cachedParticles == null)
            return false;
        // js.Lib.debug();
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
        
        particle.Initalize(x, y, vX, vY, fX, fY, ttl, damping, 0, top, externalForce!=null?externalForce:ZERO_FORCE, spriteParticleManager.sequencesList[data1], data2, data3, data4,data5);

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
                //spriteX:Float,spriteY:Float,dim:Float
                var frame = particle.sequence.sequence[Std.int(Math.min(particle.currentFrame,particle.sequence.len-1))];
                renderer.AddSpriteToBatch(frame.x,frame.y,frame.w,frame.h,particle.pX,particle.pY,particle.size,1,particle.flipX,particle.flipY,0);
                // renderer.AddSpriteToBatch(Std.int(particle.type),particle.pX,particle.pY,particle.size,Std.int(particle.alpha*255),0xFF,0xFF,0xFF);
                particle = particle.next;
            }
        }
    }
    
}