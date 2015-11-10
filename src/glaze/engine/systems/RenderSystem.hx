package glaze.engine.systems;

import glaze.engine.components.Display;
import glaze.engine.components.Position;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.eco.core.System;
import glaze.eco.core.View;
import glaze.geom.Vector2;
import glaze.render.display.Camera;
import glaze.render.display.DisplayObjectContainer;
import glaze.render.display.Stage;
import glaze.render.renderers.webgl.WebGLRenderer;
import glaze.render.texture.TextureManager;
import glaze.render.display.Sprite;
import js.Browser;
import js.html.CanvasElement;

class RenderSystem extends System {

    public var stage:Stage;
    public var camera:Camera;
    public var renderer:WebGLRenderer;
    public var textureManager:TextureManager;

    public var itemContainer:DisplayObjectContainer;

    public var canvas:CanvasElement;

    var cameraTarget:Vector2;

    public function new(canvas:CanvasElement) {
        super([Position,Display]);
        this.canvas = canvas;
        initalizeWebGlRenderer();
    }

    function initalizeWebGlRenderer() {
        stage = new Stage();
        camera = new Camera();
        
        camera.worldExtentsAABB = new glaze.geom.AABB2( 0 , 4096 , 4096 , 0 );
        camera.worldExtentsAABB.expand(-16);

        stage.addChild(camera);

        renderer = new WebGLRenderer(stage,camera,canvas,800,640);
        camera.Resize(renderer.width,renderer.height);

        textureManager  = new TextureManager(renderer.gl);

        itemContainer = new DisplayObjectContainer();
        itemContainer.id = "itemContainer";
        camera.addChild(itemContainer);
    }

    override public function entityAdded(entity:Entity) {
        var position = entity.getComponent(Position);
        var display = entity.getComponent(Display);
        display.displayObject = new Sprite();//createSprite("",display.textureID);
        display.onChange = onChange;
        display.displayObject.position = position.coords;
        updateSprite(display.displayObject,"",display.textureID);
        itemContainer.addChild(display.displayObject);
    }

    override public function entityRemoved(entity:Entity) {
        var display = entity.getComponent(Display);
        itemContainer.removeChild(display.displayObject);
    }

    override public function update(timestamp:Float,delta:Float) {
        camera.Focus(cameraTarget.x,cameraTarget.y);
        renderer.Render(camera.viewPortAABB);
    }

    //Fixme
    public function CameraTarget(target:Vector2) {
        cameraTarget = target;
    }

    function onChange(display:Display) {
        updateSprite(display.displayObject,"",display.textureID);
    }

    function updateSprite(s:Sprite,id:String,tid:String) {
        s.id = id;
        s.texture = textureManager.textures.get(tid);
        s.pivot.x = s.texture.frame.width * s.texture.pivot.x;
        s.pivot.y = s.texture.frame.height * s.texture.pivot.y;        
    }

    function createSprite(id:String,tid:String) {
        var s = new Sprite();
        s.id = id;
        s.texture = textureManager.textures.get(tid);
        s.position.x = 0;
        s.position.y = 0;
        s.pivot.x = s.texture.frame.width * s.texture.pivot.x;
        s.pivot.y = s.texture.frame.height * s.texture.pivot.y;
        // s.scale.setTo(10,10);
        return s;
    }

}