package exile.entities.creatures;

import exile.components.Bee;
import exile.components.Chicken;
import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.animation.components.SpriteAnimation;
import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.engine.components.Active;
import glaze.engine.components.Age;
import glaze.engine.components.Destroy;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Health;
import glaze.engine.components.Holdable;
import glaze.engine.components.LifeCycle;
import glaze.engine.components.Moveable;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Script;
import glaze.engine.core.EngineLifecycle.CreateLifeCylce;
import glaze.lighting.components.Light;
import glaze.physics.Body;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class ChickenFactory {

    public static var CHICKEN_LIFECYCLE = CreateLifeCylce(null,null,onDestroy,null);

	public function new() {
	}   

	public static function create(engine:Engine,position:Position):Entity {
 
        var filter = new Filter();
        // filter.categoryBits |= exile.ExileFilters.PROJECTILE_COLLIDABLE_CAT;
        // filter.maskBits |= exile.ExileFilters.PROJECTILE_CAT;

        // var chickenBody = new Body(new Material(0.01,1.0,0.1));
        var chickenBody = new Body(Material.NORMAL);
        chickenBody.setBounces(3);     
        chickenBody.maxScalarVelocity = 1000; 
        // chickenBody.globalForceFactor = 0.5;

        var chicken = engine.createEntity([
            position, 
            new Chicken(),
            // new LifeCycle(CHICKEN_LIFECYCLE),
            new Extents(12,12),
            new Display("chicken"), 
            new PhysicsCollision(false,filter,[]),
            new PhysicsBody(chickenBody,true), 
            new Moveable(),
            new Holdable(),
            new SpriteAnimation("chicken",["walk"],"walk"),
            new Health(10,10,0,onDestroy),
            new Active()
        ],"chicken"); 

        return chicken; 	    
	}

    public static function onDestroy(entity:Entity) {
        trace('DESTROY THE CHICKEN ${entity.name}');        
        entity.addComponent(new glaze.engine.components.ParticleEmitters([new glaze.particle.emitter.Explosion(1,200)]));
        entity.addComponent(new Destroy(2)); 
    }


}