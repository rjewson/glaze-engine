package glaze.engine.factories.tmxcastle;

import glaze.eco.core.IComponent;
import glaze.tmx.TmxMap;

typedef Components = Array<IComponent>;

typedef ComponentFactory = {
    id: String,
    create: Void -> Components
}

class TmxCastleFactory {
    
    var map:Map<String,ComponentFactory>;
    var tmxMap:TmxMap;

    public function new(tmxMap:TmxMap) {
        this.tmxMap = tmxMap;
        map = new Map<String,ComponentFactory>();
    }

    public function parse(groupName:String) {
        var objs = tmxMap.getObjectGroup(groupName);
		for (obj in objs.objects) {
			trace(obj.type);
            var result = new Components();
            result.push(new glaze.engine.components.TMX(obj.combined));
            result.push(new glaze.engine.components.Position(obj.x,obj.y));
            result.push(new glaze.engine.components.Extents(obj.width,obj.height));            
        }
    }

	public function registerFactory(factory:ComponentFactory) {
		map.set(factory.id,factory);
	}

}