package glaze.lighting.systems;

import glaze.ds.Bytes2D;
import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.eco.core.Entity;
import glaze.geom.Vector2;
import glaze.lighting.components.FloodLight;
import glaze.physics.collision.Map;
import glaze.render.renderers.webgl.PointSpriteLightMapRenderer;

class FloodLightingSystem extends System {
    
    public var renderer:PointSpriteLightMapRenderer;

    public var lightGrid:Bytes2D;

    public var map:Map;

    public function new(map:Map) {
        super([Position,FloodLight]);
        this.map = map;
        renderer = new PointSpriteLightMapRenderer();
        renderer.ResizeBatch(32*32);
        lightGrid = new Bytes2D(32,32,32,1);
    }

    override public function entityAdded(entity:Entity) {
        trace("added light");
    }
    
    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        reset();
        renderLightsToLightGrid();
        renderLightGridToSprites();
    }

    public function reset() {
        renderer.ResetBatch();
        for (i in 0...lightGrid.data.length)
            lightGrid.data.set(i,255);
    }

    public function renderLightsToLightGrid() {
        for (entity in view.entities) {
            var position = entity.getComponent(Position);
            var light = entity.getComponent(FloodLight);

            //renderFunc1(lightGrid.Index(position.coords.x),lightGrid.Index(position.coords.y),light.range);
            renderFunc1(position.coords,light.range);
        } 
    }

    public function renderFunc1(position:Vector2,range:Float) {
        var startX = lightGrid.Index(Math.max(0,position.x-range));
        var startY = lightGrid.Index(Math.max(0,position.y-range));
        var endX = lightGrid.Index(Math.min(31*32,position.x+range)) + 1;
        var endY = lightGrid.Index(Math.min(31*32,position.y+range)) + 1;
        // trace(startX,endX,startY,endY);
        for (xpos in startX...endX) {
            for (ypos in startY...endY) {
                var dX = position.x - (xpos*32)+16;
                var dY = position.y - (ypos*32)+16;
                var pcent = (dX*dX+dY*dY)/(range*range);
                if (pcent>=1)
                    continue;
                var iv = Std.int(Math.min(Math.max(pcent*255,0),255));
                var currentLight = lightGrid.get(xpos,ypos,0);
                if (currentLight<iv)
                    continue;
                lightGrid.set(xpos,ypos,0,iv);
            }
        }
    }

    public function renderLightGridToSprites() {
        for (y in 0...lightGrid.height-1) {
            for (x in 0...lightGrid.width-1) {
                var v = lightGrid.get(x,y,0);
                renderer.AddSpriteToBatch(x*32,y*32,32,v,0x00,0x00,0x00);
            }
        }        
    }

}