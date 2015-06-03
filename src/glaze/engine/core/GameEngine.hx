package glaze.engine.core;

import glaze.core.DigitalInput;
import glaze.geom.Vector2;
import glaze.util.AssetLoader;
import glaze.core.GameLoop;
import glaze.eco.core.Engine;
import js.html.CanvasElement;

class GameEngine {

    public var assets:AssetLoader;
    public var loop:GameLoop;
    public var input:DigitalInput;
    public var engine:Engine;

    public var canvas:CanvasElement;

    public function new(canvas:CanvasElement) {
        this.canvas = canvas;
        loop = new GameLoop();
        loop.updateFunc = update;

        input = new DigitalInput();
        var rect = canvas.getBoundingClientRect();
        input.InputTarget(js.Browser.document,new Vector2(rect.left,rect.top));

        engine = new Engine();
    }

    public function loadAssets(assetList:Array<String>) {
        assets = new AssetLoader(); 
        assets.loaded.add(initalize);
        assets.SetImagesToLoad(assetList);
        assets.Load();
    }

    public function initalize() {
    }

    public function update(delta:Float,now:Int) {
        input.Update(0,0);
        preUpdate();
        engine.update(now,delta);
        // trace("gameEngine");
    }

    public function preUpdate(){
    }

}