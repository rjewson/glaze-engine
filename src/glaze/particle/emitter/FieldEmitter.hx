
package glaze.particle.emitter;

import glaze.eco.core.Entity;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.particle.IParticleEngine;
import glaze.util.Random.RandomFloat;

class FieldEmitter implements IParticleEmitter
{

    var startX:Int;
    var startY:Int;
    var endX:Int;
    var endY:Int;

    public function new() {
    }

    public function init() {
        // startX = data.Index(Math.min(body.position.x,body.predictedPosition.x) - proxy.aabb.extents.x - CORRECTION);
        // startY = data.Index(Math.min(body.position.y,body.predictedPosition.y) - proxy.aabb.extents.y - CORRECTION);

        // endX = data.Index(Math.max(body.position.x,body.predictedPosition.x) + proxy.aabb.extents.x + CORRECTION - ROUNDDOWN) + 1;
        // endY = data.Index(Math.max(body.position.y,body.predictedPosition.y) + proxy.aabb.extents.y + CORRECTION ) + 1;

        // for (x in startX...endX) {
        //     for (y in startY...endY) { 
    }

    public function update(time:Float, entity:Entity, engine:IParticleEngine):Void {
        var position = entity.getComponent(Position).coords;
        var extents = entity.getComponent(Extents).halfWidths;
        for (y in 5...25 ) {  
            for (x in 15...20) {
               engine.EmitParticle((x*32)-16,(y*32)-16,0,0,0,0,17,1,false,true,null,32,128,255,255,255);             
            }
        }

    }

}