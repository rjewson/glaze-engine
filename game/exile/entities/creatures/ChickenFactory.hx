package exile.entities.creatures;

import exile.components.Bee;
import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
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
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class ChickenFactory {

    public static var frameList:FrameList;

	public function new()
	{
	    
	} 

	public static function create(engine:Engine,position:Position):Entity {

        var chickenBody = new Body(new Material());
        chickenBody.setMass(0.01);
        chickenBody.setBounces(3);     
        chickenBody.maxScalarVelocity = 1000; 
        chickenBody.globalForceFactor = 0.5;

          
        var animationController = new glaze.animation.core.AnimationController(ChickenFactory.frameList);
        animationController.add("walk",[0,1,2,3,4,5],4);
        animationController.play("walk");

        var chicken = engine.createEntity([
            position, 
            new exile.components.Chicken(),
            new Extents((16/2)*2,(16/2)*2),
            new Display("chicken/frame-001.png"), 
            new PhysicsCollision(false,new glaze.physics.collision.Filter(),[]),
            new PhysicsBody(chickenBody), 
            new Moveable(),
            new Holdable(),
            // new ParticleEmitters([new glaze.particle.emitter.RandomSpray(50,10)]),
            new glaze.animation.components.SpriteAnimation(animationController),
            new Health(10,10,0),
            new Active()
        ],"chicken"); 

        chicken.getComponent(Display).displayObject.scale.setTo(2,2);

        return chicken; 	    
	}

}