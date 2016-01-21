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

class BeeFactory {

	public function new() {
	} 

	public static function create(engine:Engine,position:Position):Entity {

        var beeBody = new Body(new Material());
        beeBody.setMass(0.1);
        beeBody.setBounces(0);     
        beeBody.globalForceFactor = 0;
        beeBody.maxScalarVelocity = 100; 
          
        var bee = engine.createEntity([
            position, 
            new Bee(),
            new Extents((15/2)*1.5,(11/2)*1.5),
            new Display("bat"), 
            new PhysicsBody(beeBody), 
            new Moveable(),
            new PhysicsCollision(false,null,[]),  
            // new ParticleEmitters([new glaze.particle.emitter.RandomSpray(50,10)]),
            new glaze.animation.components.SpriteAnimation("bat",["fly"],"fly"),
            new Light(64,1,1,1,255,255,0),
            new Steering([
                new Wander()
                ]),
            new Age(10000),
            new Health(10,10,0),
            new Active()
        ],"bee"); 

        return bee; 	    
	}

}