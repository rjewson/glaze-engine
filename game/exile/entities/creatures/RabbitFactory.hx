package exile.entities.creatures;

import exile.components.Rabbit;
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

class RabbitFactory {

	public function new() {
	} 

	public static function create(engine:Engine,position:Position):Entity {
        var v = new Vector2();
        var rabbitBody = new Body(Material.NORMAL);
        rabbitBody.setBounces(3);     
        rabbitBody.maxScalarVelocity = 1000; 
        rabbitBody.globalForceFactor = 1;

        var rabbit = engine.createEntity([
            position,  
            new Rabbit(),
            new Extents((12),(16)),
            new Display("rabbit"), 
            new PhysicsCollision(false,new Filter(),[]),
            new PhysicsBody(rabbitBody,true), 
            new Moveable(),
            new Holdable(),
            new SpriteAnimation("rabbit",["idle","blink","jump","eat","listen"],"jump"),
            new Health(10,10,0,null),
            new Active()
            // new glaze.ai.steering.components.Steering([
            //     new glaze.ai.steering.behaviors.Wander(4,1,1)
            // ])
        ],"rabbit"); 

        return rabbit; 	    
	}

}