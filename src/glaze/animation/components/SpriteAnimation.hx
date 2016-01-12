package glaze.animation.components;

import glaze.render.animation.AnimationController;
import glaze.geom.Vector2;
import glaze.eco.core.IComponent;
import glaze.render.display.Sprite;

class SpriteAnimation implements IComponent {
    
    public var frameListId:String;
    public var initialAnimation:String;
    public var animations:Array<String>;

    public var animationController:AnimationController;

    public function new(frameListId:String, animations:Array<String>, initialAnimation:String) {
    	this.frameListId = frameListId;
    	this.animations = animations;
    	this.initialAnimation = initialAnimation;
    }

}