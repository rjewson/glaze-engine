package exile.entities.projectile;

import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Script;
import glaze.lighting.components.Light;
import glaze.physics.Body;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;

class StandardBullet {
	
	public function new()
	{
	    
	}

	public function create(engine:Engine,position:Position,filter:Filter):Entity {

        var bulletBody = new Body(new Material());
        bulletBody.setMass(0.03);
        bulletBody.setBounces(3);     
        bulletBody.globalForceFactor = 1;
        bulletBody.isBullet = true;

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

        var bullet = engine.createEntity([
            position,
            new Extents(3,3),
            new Display("projectile1.png"), 
            new PhysicsBody(bulletBody), 
            new PhysicsCollision(false,filter,[]),  
            new ParticleEmitters([new glaze.particle.emitter.InterpolatedEmitter(0,10)]),
            new exile.components.Projectile("bullet")
            // new Script(behavior),
            // new Steering([
            //     new Seek(new Vector2(0,0))
            //     // new Wander()
            //     ])
        ],"StandardBullet");              
                

        var light = engine.createEntity([
            position,
            new Light(64,1,1,1,255,0,0),
            new Extents(64,64)
        ],"StandardBullet Light");

        bullet.addChildEntity(light);

        return bullet;

	}
}