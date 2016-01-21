package exile.entities.creatures;

import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.animation.components.SpriteAnimation;
import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.engine.components.Active;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Holdable;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.physics.Body;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;

class FishFactory {

	public function new() {
	} 

	public static function create(engine:Engine,position:Position):Entity {

        var fish = engine.createEntity([
            position,
            new Extents(4,4),
            new Display("fish2"), 
            new PhysicsCollision(false,new Filter(),[]),
            new Moveable(),
            new PhysicsBody(Body.Create(null,0.1,0,0.5,100)),
            new Holdable(),
            new Active(),
            new SpriteAnimation("fish2",["swim"],"swim"),
            new glaze.ai.steering.components.Steering([
                new glaze.ai.steering.behaviors.Wander(18,1,4)
            ])
        ],"fish"); 
	    
        return fish;

	}

}