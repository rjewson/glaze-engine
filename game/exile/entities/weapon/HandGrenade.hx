package exile.entities.weapon;

import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Health;
import glaze.engine.components.Holdable;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.engine.components.State;
import glaze.physics.Body;
import glaze.physics.Material;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;

class HandGrenade {
	
	public static function create(engine:Engine,x:Float,y:Float):Entity {

        var body = new glaze.physics.Body(new Material());
        body.maxScalarVelocity = 200;
 
        var grenade = engine.createEntity([
            new Position(336,150),  
            new Display("grenade.png"), 
            new Extents(8,8),
            new PhysicsCollision(false,new Filter(),[]),
            new Moveable(),
            new PhysicsBody(body),
            new Holdable(),
            new exile.components.Grenade(),
            new Health(100,100,0),
            new State(['off','on'],0,[])
        ],"grenade"); 

        return grenade;

	}

}