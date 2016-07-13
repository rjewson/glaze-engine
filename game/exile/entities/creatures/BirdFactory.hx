package exile.entities.creatures;

import exile.components.Bird;
import exile.components.BirdNest;
import glaze.ai.faction.components.Personality;
import glaze.ai.steering.behaviors.Arrival;
import glaze.ai.steering.behaviors.Seek;
import glaze.ai.steering.behaviors.WallAvoidance;
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
import glaze.physics.collision.Map;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.physics.systems.PhysicsCollisionSystem;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;
import glaze.util.EntityUtils;

class BirdFactory {

    public static var map:Map;

	public function new() {
	} 

	public static function create(engine:Engine,position:Position,follow:Position,nest:Entity):Entity {

        var birdBody = new Body(new Material());
        birdBody.setMass(1);
        birdBody.setBounces(0);     
        birdBody.globalForceFactor = 0.0;
        birdBody.maxScalarVelocity = 200; 

        var map:Map = cast engine.config.map;

        var bird = engine.createEntity([
            position, 
            new Bird(nest),
            new Extents((4)*1,(4)*1),
            new Display("bird"), 
            new PhysicsBody(birdBody,false), 
            new Moveable(),
            new PhysicsCollision(false,null,[]),  
            new SpriteAnimation("bird",["fly"],"fly"),
            // new Light(64,1,1,1,255,255,0),
            nest.getComponent(Personality).clone(),
            new Steering([
                new Wander(55,80,0.3) //ok
                ,new Arrival(follow.coords,256)
                //,new Seek(follow.coords,32)
                // new Arrival(follow.coords,128,32)
                ,new WallAvoidance(map,60)
                ,new glaze.ai.steering.behaviors.Seperation(nest.getComponent(BirdNest).group.members,20)
                ]),
            new Age(5000,EntityUtils.standardDestroy),
            new Health(10,10,0,EntityUtils.standardDestroy),
            new Active()
        ],"bird"); 

        return bird; 	    
	}

}