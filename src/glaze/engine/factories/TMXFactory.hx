package glaze.engine.factories;

import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.engine.factories.ComponentFactory;
import glaze.engine.factories.IEntityFactory;
import glaze.tmx.TmxMap;
import glaze.tmx.TmxObject;

class TMXFactory {
	
	var engine:Engine;
	var tmxMap:TmxMap;
	var map:Map<String,IEntityFactory>;

	public function new(engine:Engine,tmxMap:TmxMap) {
		this.engine = engine;
	    this.tmxMap = tmxMap;
	    map = new Map<String,IEntityFactory>();
	}

	public function parseObjectGroup(groupName:String) {
		var objs = tmxMap.getObjectGroup(groupName);
		for (obj in objs.objects) {
			var factory = map.get(obj.type);
			if (factory!=null) {
				factory.createEntity(obj,engine);
			}
        }
	}

	public function registerFactory(factory:Class<IEntityFactory>) {
		var factoryInstance = Type.createInstance(factory,[]);
		map.set(factoryInstance.mapping,factoryInstance);
	}

}