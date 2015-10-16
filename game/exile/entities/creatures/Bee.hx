package exile.entities.creatures;

import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.eco.core.Engine;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Moveable;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Script;
import glaze.lighting.components.Light;
import glaze.physics.Body;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;

class Bee {

	public function new()
	{
	    
	}

	public function create(engine:Engine,position:Position) {

        var beeBody = new Body(new Material());
        beeBody.setMass(0.03);
        beeBody.setBounces(0);     
        beeBody.globalForceFactor = 0;
        beeBody.maxScalarVelocity = 100; 
          
        var behavior = new glaze.ai.behaviortree.Sequence();
        behavior.addChild(new glaze.engine.actions.Delay(10000,1000));
        behavior.addChild(new glaze.engine.actions.DestroyEntity());

        engine.createEntity([
            position, 
            new Extents(3,3),
            new Display("projectile1.png"), 
            new PhysicsBody(beeBody), 
            new Moveable(),
            new PhysicsCollision(false,null,[]),  
            new ParticleEmitters([new glaze.particle.emitter.RandomSpray(50,10)]),
            new Script(behavior),
            new Light(64,1,1,1,255,255,0),
            new Steering([
                new Wander()
                ])
        ],"bee");  	    
	}

}