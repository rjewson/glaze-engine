package exile.entities.creatures;

import exile.components.Bee;
import glaze.ai.steering.behaviors.Seek;
import glaze.ai.steering.behaviors.WallAvoidance;
import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.ai.steering.SteeringAgentParameters;
import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.engine.components.Active;
import glaze.engine.components.Age;
import glaze.engine.components.Destroy;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Health;
import glaze.engine.components.LifeCycle;
import glaze.engine.components.Moveable;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Script; 
import glaze.engine.core.EngineLifecycle;
import glaze.lighting.components.Light;
import glaze.physics.Body;
import glaze.physics.collision.Map;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.physics.systems.PhysicsCollisionSystem;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class BeeFactory {

    public static var map:Map;

    // public static var BEE_LIFECYCLE = EngineLifecycle.CreateLifeCylce(onInitalize,null,onDestroy,null);

	public function new() {
	} 

	public static function create(engine:Engine,position:Position):Entity {

        var beeBody = new Body(new Material(0.1,0.3,0));
        beeBody.setMass(0.1);
        beeBody.setBounces(0);     
        beeBody.globalForceFactor = 0.0;
        beeBody.maxScalarVelocity = 200; 

        var bee = engine.createEntity([
            position, 
            new Bee(),
            // new LifeCycle(BEE_LIFECYCLE),
            new Extents((3/2)*1,(3/2)*1),
            new Display("insects"), 
            new PhysicsBody(beeBody,true), 
            new Moveable(),
            new PhysicsCollision(false,null,[]),  
            // new ParticleEmitters([new glaze.particle.emitter.RandomSpray(100,10)]),
            new glaze.animation.components.SpriteAnimation("insects",["firefly"],"firefly"),
            // new Light(64,1,1,1,255,255,0),
            new Steering([
                new Wander(80,40,143.5)
                ,new Seek(position.coords.clone(),32)
                // ,new WallAvoidance(map,40)
                ],SteeringAgentParameters.HEAVY_STEERING_PARAMS),
            new Age(10000,onDestroy),
            new Health(10,10,0,onDestroy),
            new Active()
        ],"bee"); 

        return bee; 	    
	}

    public static function onInitalize(entity:Entity) {
        trace('INIT THE BEE ${entity.name}');        
    }

    public static function onDestroy(entity:Entity) {
        // js.Lib.debug();
        trace('DESTROY THE BEE ${entity.name}');        
        entity.addComponent(new glaze.engine.components.ParticleEmitters([new glaze.particle.emitter.Explosion(1,200)]));
        entity.addComponent(new Destroy(0)); 
    }

}