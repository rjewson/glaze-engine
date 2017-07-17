package exile.entities.projectile;

import glaze.engine.components.CollisionCounter;
import glaze.engine.components.Destroy;
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
import glaze.physics.Body;
import glaze.physics.Material;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;

class PlasmaProjectileFactory {
	
	public function new() {
	} 

	public static function create(engine:Engine,position:Position,filter:Filter,targetPosition:Vector2):Entity {

        var bulletBody = new Body(Material.LIGHTMETAL);
        bulletBody.setMass(0.3);
        bulletBody.setBounces(0);     
        bulletBody.globalForceFactor = 0.1;
        bulletBody.isBullet = true;

        var bullet = engine.createEntity([
            position,
            new Extents(3,3),
            new Display("projectiles","plasma"), 
            new PhysicsBody(bulletBody,false),
            new Moveable(),
            new PhysicsCollision(false,filter,[]),   
            new ParticleEmitters([new glaze.particle.emitter.FireballEmitter(0,10)]),
            // new Projectile({ttl:1000,bounce:1,power:10,range:32}),
            new CollisionCounter(1,onDestroy),
            new Health(10,10,0,onDestroy),
            new Age(1000,onDestroy),
            new Active()
            // new Script(behavior),
            // new Steering([
            //     new Seek(new Vector2(0,0))
            //     // new Wander()
            //     ])
        ],"StandardBullet");              
                
        glaze.util.Ballistics.calcProjectileVelocity(bulletBody,targetPosition,600);        

        // var light = engine.createEntity([
        //     position,
        //     new Light(64,1,1,1,255,0,0),
        //     new Extents(64,64)
        // ],"StandardBullet Light");

        // bullet.addChildEntity(light);

        return bullet;

	}

    public static function onDestroy(entity:Entity) {
        if (entity.getComponent(Destroy)!=null)
            return;
        entity.addComponent(new Destroy(1)); 
        entity.getComponent(glaze.engine.components.ParticleEmitters).emitters.push(new glaze.particle.emitter.Explosion(10,50));
        glaze.util.CombatUtils.explode(entity.getComponent(Position).coords,64,10000,entity);
    }


}