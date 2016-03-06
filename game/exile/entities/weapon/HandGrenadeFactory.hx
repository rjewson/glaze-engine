package exile.entities.weapon;

import exile.components.Grenade;
import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.engine.components.Active;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Health;
import glaze.engine.components.Holdable;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.engine.components.State;
import glaze.engine.components.Storeable;
import glaze.physics.Body;
import glaze.physics.Material;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;

class HandGrenadeFactory {
	
    public static var count:Int = 0;

	public static function create(engine:Engine,x:Float,y:Float):Entity {

        var body = new glaze.physics.Body(new Material());
        body.maxScalarVelocity = 200;
 
        var grenade = engine.createEntity([
            new Position(x,y),  
            new Display("grenade","off"), 
            new Extents(8,8),
            new PhysicsCollision(false,new Filter(),[]),
            new Moveable(),
            new PhysicsBody(body,false),
            new Holdable(),
            new Storeable(),
            new Grenade(),
            new Health(100,100,0),
            new State(['off','on'],0,[]),
            new Active()
        ],"grenade"+(count++)); 

        return grenade;

	}

}