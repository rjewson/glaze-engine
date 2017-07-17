package glaze.engine.systems;

import glaze.engine.components.Active;
import glaze.engine.components.Display;
import glaze.engine.components.Position;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.eco.core.System;
import glaze.eco.core.View;
import glaze.engine.components.TileDisplay;
import glaze.geom.Vector2;
import glaze.physics.collision.Map;
import glaze.render.display.Camera;
import glaze.render.display.DisplayObjectContainer;
import glaze.render.display.Stage;
import glaze.render.frame.FrameListManager;
import glaze.render.renderers.webgl.TileMap;
import glaze.render.renderers.webgl.WebGLRenderer;
import glaze.render.texture.TextureManager;
import glaze.render.display.Sprite;
import haxe.ds.StringMap;
import js.Browser;
import js.html.CanvasElement;

class TileRenderSystem extends System {

    public var updates:Array<Entity>;

    public var frames:StringMap<Array<Int>>;

    public var tileMap:TileMap;
    public var map:Map;

    public function new(tileFramesConfig:Dynamic,tileMap:TileMap,map:Map) {
        super([Position,TileDisplay]);
        updates = new Array<Entity>();
        frames = new StringMap<Array<Int>>();
        this.tileMap = tileMap;
        this.map = map;
        parseFramesConfig(tileFramesConfig);
    } 
 
    //Format
    // "switchOn":[x,y,w,h,cx,cy] 64 32 32 32 32  
    //                               5  4 4 4 4
    //                              16 12 8 4 0

    function parseFramesConfig(config:Dynamic) {
        if (!Std.is(config, String)) 
            return;
        // js.Lib.debug();
        var data = haxe.Json.parse(config);
        var sheetNumber:Int = 0;

        var config = Reflect.field(data,"sheets");
        for (sheetId in Reflect.fields(config)) {
            var sheet = Reflect.field(config, sheetId);

            for ( frameId in Reflect.fields(sheet) ) {
                var frameData:Array<Int> = Reflect.field(sheet, frameId);
                //trace(frameId,sheetNumber,frameData[0],frameData[1],frameData[2],frameData[3]);
                frameData.push(sheetNumber); //At the back for now
                frames.set(frameId,frameData);
            }

            sheetNumber++;
        }
    }

    override public function entityAdded(entity:Entity) {
        var position = entity.getComponent(Position);
        var tileDisplay = entity.getComponent(TileDisplay);
        tileDisplay.onChange = onChange.bind(entity);
        if (tileDisplay.tileFrameId!=null)
            onChange(entity);
    }

    override public function entityRemoved(entity:Entity) {
    }

    public function onChange(entity:Entity) {
        updates.push(entity); //entity.getComponent(TileDisplay).tileFrameId
    }

    override public function update(timestamp:Float,delta:Float) {
        while (updates.length>0) {
            // js.Lib.debug();
            var entity = updates.pop();
            var position = entity.getComponent(Position);
            var tileDisplay = entity.getComponent(TileDisplay);
            if (tileDisplay.tileFrameId!="")
                tileMap.updateMap(map.data.Index(position.coords.x),map.data.Index(position.coords.y),frames.get(tileDisplay.tileFrameId));
            
            trace(tileDisplay);
        }
    }

}