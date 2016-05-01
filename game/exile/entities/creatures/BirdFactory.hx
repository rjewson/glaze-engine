package exile.entities.creatures;

import exile.components.Bird;
import glaze.ai.steering.behaviors.Arrival;
import glaze.ai.steering.behaviors.Seek;
import glaze.ai.steering.behaviors.WallAvoidance;
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
import glaze.physics.collision.Map;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.physics.systems.PhysicsCollisionSystem;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class BirdFactory {

    public static var map:Map;

	public function new() {
	} 

	public static function create(engine:Engine,position:Position,follow:Position):Entity {

        var birdBody = new Body(new Material());
        birdBody.setMass(1);
        birdBody.setBounces(0);     
        birdBody.globalForceFactor = 0.0;
        birdBody.maxScalarVelocity = 200; 

        var map:Map = cast engine.config.map;

        var bird = engine.createEntity([
            position, 
            new Bird(),
            new Extents((3)*1,(3)*1),
            new Display("bird"), 
            new PhysicsBody(birdBody,true), 
            new Moveable(),
            new PhysicsCollision(false,null,[]),  
            // new ParticleEmitters([new glaze.particle.emitter.RandomSpray(100,10)]),
            new glaze.animation.components.SpriteAnimation("bird",["fly"],"fly"),
            // new Light(64,1,1,1,255,255,0),
            new Steering([
                // new Wander(4,10,0.01),
                // new Arrival(position.coords.clone(),64,8)
                // new Seek(follow.coords,32)
                new Arrival(follow.coords,64,16)
                ,new WallAvoidance(map,40)
                ]),
            new Age(10000),
            new Health(10,10,0),
            new Active()
        ],"bird"); 

        return bird; 	    
	}

}