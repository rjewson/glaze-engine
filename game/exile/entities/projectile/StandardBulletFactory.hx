package exile.entities.projectile;

import exile.components.Projectile;
import glaze.engine.components.CollisionCounter;
import glaze.engine.components.Destroy;
import glaze.engine.components.LifeCycle;
import glaze.engine.core.EngineLifecycle.CreateLifeCylce;
import glaze.geom.Vector2;
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
import glaze.lighting.components.Light;
import glaze.physics.Body;
import glaze.physics.Material;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.render.frame.FrameList;

class StandardBulletFactory {
	
    public static var BULLET_LIFECYCLE = CreateLifeCylce(null,null,onDestroy,null);

	public function new() {
	} 

	public static function create(engine:Engine,position:Position,filter:Filter,targetPosition:Vector2):Entity {

        var bulletBody = new Body(Material.LIGHTMETAL);
        bulletBody.setMass(16+8);
        bulletBody.setBounces(3);     
        bulletBody.globalForceFactor = 1;//0.5;
        bulletBody.isBullet = true;
        bulletBody.maxScalarVelocity = 10000;

        filter.categoryBits |= exile.ExileFilters.PROJECTILE_CAT;
        filter.maskBits     |= exile.ExileFilters.PROJECTILE_COLLIDABLE_CAT;

/*
        var data = '
        {
            "type":"Sequence",
            "children": [
                {
                    "type":"Monitor",
                    "children": [
                        {
                            "type":"glaze.engine.actions.Delay",
                            "params":[1000,100]
                        },
                        {
                            "type":"glaze.engine.actions.CollisionMonitor"
                        }
                    ]
                },
                {
                    "type":"glaze.engine.actions.DestroyEntity"
                }

            ]
        }';
		var include:glaze.engine.actions.CollisionMonitor;
        var behavior = glaze.ai.behaviortree.BehaviorTree.fromJSON(data);
*/
        var bullet = engine.createEntity([
            position,
            new Extents(2,2),
            // new LifeCycle(BULLET_LIFECYCLE),
            new Display("projectiles","standard"), 
            new PhysicsBody(bulletBody,true),
            new Moveable(),
            new PhysicsCollision(false,filter,[]),   
            new ParticleEmitters([new glaze.particle.emitter.InterpolatedEmitter(0,10)]),
            // new Projectile({ttl:1000,bounce:3,power:10,range:32}),
            new CollisionCounter(3,onDestroy),
            new Health(10,10,0,onDestroy),
            new Age(1000,onDestroy),
            new Active()
            // new Script(behavior),
            // ,new glaze.ai.steering.components.Steering([
            //     // new Seek(new Vector2(0,0))
            //     new glaze.ai.steering.behaviors.Wander(55,80,0.3)
            //     ])
        ],"StandardBullet");              
                
        glaze.util.Ballistics.calcProjectileVelocity(bulletBody,targetPosition,2500);        

        // var light = engine.createEntity([
        //     position,
        //     new Light(64,1,1,1,255,0,0),
        //     new Extents(64,64)
        // ],"StandardBullet Light");

        // bullet.addChildEntity(light);

        return bullet;

	}

    public static function onDestroy(entity:Entity) {
        // js.Lib.debug();
        if (entity.getComponent(Destroy)!=null)
            return;
        entity.addComponent(new Destroy(1)); 
        entity.getComponent(glaze.engine.components.ParticleEmitters).emitters.push(new glaze.particle.emitter.Explosion(10,50));
        glaze.util.CombatUtils.explode(entity.getComponent(Position).coords,64,10000,entity);
    }


}