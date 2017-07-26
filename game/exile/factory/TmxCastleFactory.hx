package exile.factory;

import glaze.eco.core.IComponent;
import glaze.tmx.TmxMap;
import glaze.tmx.TmxObject; 
import glaze.eco.core.Engine;
import glaze.engine.components.Position;
import glaze.engine.components.Extents;
import dat.Data;

typedef Components = Array<IComponent>;

typedef ComponentFactory = {
    id: String,
    create: Components -> Components
}

class TmxCastleFactory {
    
    var factories:Map<String,ComponentFactory>;
    var engine:Engine;
    var tmxMap:TmxMap;   

    public function new(engine:Engine, tmxMap:TmxMap) {
        this.engine = engine;
        this.tmxMap = tmxMap;
        factories = new Map<String,ComponentFactory>();
        dat.Data.StateType.On.getName();
    }

    public function parse(groupName:String) {
        var objs = tmxMap.getObjectGroup(groupName);
		for (obj in objs.objects) {
			trace(obj.type);
            var components = new Components();
            components.push(new glaze.engine.components.TMX(obj.combined));
            components.push(createPositionFromTMX(obj));
            components.push(createExtentsFromTMX(obj));
            var factory = factories.get(obj.type);
            if (factory!=null) {
                components = factory.create(components);
                js.Lib.debug();
                engine.createEntity(components,obj.name);
            }
        }
    }

	public function registerFactory(factory:ComponentFactory) {
		factories.set(factory.id,factory);
	}

    public static function createPositionFromTMX(tmxObject:TmxObject):Position {
	    return new Position(SCALE(tmxObject.x+tmxObject.width/2),SCALE(tmxObject.y+tmxObject.height/2));
	}

	public static function createExtentsFromTMX(tmxObject:TmxObject):Extents {
	    return new Extents(SCALE(tmxObject.width/2),SCALE(tmxObject.height/2));
	}

	public static function SCALE(v:Float):Float {
		return v*2;
	}

}