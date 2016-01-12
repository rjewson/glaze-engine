package glaze.animation.systems;

import glaze.animation.components.SpriteAnimation;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Display;
import glaze.engine.components.Viewable;
import glaze.render.animation.AnimationController;
import glaze.render.frame.FrameListManager;

class AnimationSystem extends System {

    public var frameListManager:FrameListManager;

    public function new(frameListManager:FrameListManager) {
        super([Display,SpriteAnimation]);
        this.frameListManager = frameListManager;
    }

    override public function entityAdded(entity:Entity) {
        var animation = entity.getComponent(SpriteAnimation);
        var frameList = frameListManager.getFrameList(animation.frameListId);
        animation.animationController = new AnimationController(frameList);
        for (sequence in animation.animations) {
            animation.animationController.addAnimation(frameList.getAnimation(sequence).clone(animation.animationController));
        }
        animation.animationController.play(animation.initialAnimation);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var display = entity.getComponent(Display);
            var animation = entity.getComponent(SpriteAnimation);
            animation.animationController.update(1/delta);
            animation.animationController.getFrame().updateSprite(display.displayObject);        
        }
    }

}