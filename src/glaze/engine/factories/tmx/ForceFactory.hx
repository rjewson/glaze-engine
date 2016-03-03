package glaze.engine.factories.tmx;

import glaze.eco.core.Engine;
import glaze.engine.components.Active;
import glaze.engine.components.EnvironmentForce;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Position;
import glaze.engine.components.Wind;
import glaze.engine.factories.tmx.TMXEntityFactory;
import glaze.engine.components.Water;
import glaze.geom.Vector2;
import glaze.physics.components.PhysicsCollision;

class ForceFactory extends TMXEntityFactory {

	public function new() {	
		super();
	}

	override public function get_mapping():String {
		return "Force";
	}

	override public function createEntity(data:Dynamic,engine:Engine) {

		setTmxObject(data);

		var components = TMXEntityFactory.getEmptyComponentArray();

		components.push(TMXEntityFactory.getPosition(tmxObject));
		components.push(TMXEntityFactory.getExtents(tmxObject));
        components.push(new PhysicsCollision(true,null,[]));
        components.push(new Fixed());
       	components.push(new Active());
		
       	var config = BaseEntityFactory.getCSVParams(tmxObject.combined.get("config"));
       	
       	var forceData:ForceData = new ForceData(config[0],config[1],config[2],config[3],config[4]);

		components.push(new EnvironmentForce([forceData]));
        components.push(new Wind(1/1000));
		
		engine.createEntity(components,tmxObject.name);

	}

}