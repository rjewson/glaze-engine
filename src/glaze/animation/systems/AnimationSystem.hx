package glaze.animation.systems;

import glaze.animation.components.SpriteAnimation;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Display;
import glaze.engine.components.Viewable;

class AnimationSystem extends System {

    public function new() {
        super([Display,SpriteAnimation]);
    }

    override public function entityAdded(entity:Entity) {
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