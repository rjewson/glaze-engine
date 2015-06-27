package glaze.engine.factories.tmx;

import glaze.eco.core.Engine;
import glaze.engine.components.Extents;
import glaze.engine.factories.tmx.TMXEntityFactory;
import glaze.lighting.components.Light;

class LightFactory extends TMXEntityFactory {

	public function new() {	
		super();
	}

	override public function get_mapping():String {
		return "Light";
	}

	override public function createEntity(data:Dynamic,engine:Engine) {

		setTmxObject(data);

		var components = TMXEntityFactory.getEmptyComponentArray();

		components.push(TMXEntityFactory.getPosition(tmxObject));

		var light = CreateEntityFromCSV(Light,tmxObject.combined.get("Light"));

		components.push(light);

		var extents = new Extents(light.range/1.5,light.range/1.5);

		components.push(extents);

		engine.createEntity(components,tmxObject.name);

	}

}