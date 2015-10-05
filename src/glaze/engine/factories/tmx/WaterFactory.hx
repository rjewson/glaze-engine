package glaze.engine.factories.tmx;

import glaze.eco.core.Engine;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.engine.factories.tmx.TMXEntityFactory;
import glaze.engine.components.Water;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.components.PhysicsStatic;

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
        components.push(new PhysicsStatic());
		var water = CreateEntityFromCSV(Water,tmxObject.combined.get("Water"));
		components.push(water);




		// var components2= TMXEntityFactory.getEmptyComponentArray();
  //       components2.push(new Position((32*33),(32*7.5)));
  //       components2.push(new Extents(64,48));
  //       components2.push(new PhysicsCollision(true,null));
  //       components2.push(new PhysicsStatic());
  //      	components2.push(new Water());

// js.Lib.debug();

		engine.createEntity(components,tmxObject.name);

	}

}