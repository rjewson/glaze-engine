package exile.entities.creatures;

import exile.components.Bee;
import exile.components.Chicken;
import exile.components.Maggot;
import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.animation.components.SpriteAnimation;
import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.engine.components.Active;
import glaze.engine.components.Age;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Health;
import glaze.engine.components.Holdable;
import glaze.engine.components.Moveable;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Script;
import glaze.lighting.components.Light;
import glaze.physics.Body;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class MaggotFactory {

	public function new() {
	} 

	public static function create(engine:Engine,position:Position):Entity {

        var maggotBody = new Body(new Material(1,0.5,0.7));
        maggotBody.setMass(0.5);
        maggotBody.setBounces(3);     
        maggotBody.maxScalarVelocity = 1000; 
        maggotBody.globalForceFactor = 1;

        var maggot = engine.createEntity([
            position, 
            new Maggot(),
            new Extents((15/2)*2,(7/2)*2),
            new Display("maggot"), 
            new PhysicsCollision(false,new Filter(),[]),
            new PhysicsBody(maggotBody), 
            new Moveable(),
            new Holdable(),
            new SpriteAnimation("maggot",["idle","blink","jump"],"jump"),
            new Health(10,10,0),
            new Active()
            // new glaze.ai.steering.components.Steering([
            //     new glaze.ai.steering.behaviors.Wander(4,1,1)
            // ])
        ],"maggot"); 

        return maggot; 	    
	}

}