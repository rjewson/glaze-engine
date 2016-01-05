package glaze.engine.factories.tmx;

import glaze.eco.core.Engine;
import glaze.engine.components.Active;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Position;
import glaze.engine.factories.tmx.TMXEntityFactory;
import glaze.engine.components.Water;
import glaze.physics.components.PhysicsCollision;

class WaterFactory extends TMXEntityFactory {

	public function new() {	
		super();
	}

	override public function get_mapping():String {
		return "Water";
	}

	override public function createEntity(data:Dynamic,engine:Engine) {

		setTmxObject(data);

		var components = TMXEntityFactory.getEmptyComponentArray();

		components.push(TMXEntityFactory.getPosition(tmxObject));
		components.push(TMXEntityFactory.getExtents(tmxObject));
        components.push(new PhysicsCollision(true,null,[]));
        components.push(new Fixed());
       	components.push(new Active());

		var water = CreateEntityFromCSV(Water,tmxObject.combined.get("Water"));
		components.push(water);

		engine.createEntity(components,tmxObject.name);

	}

}