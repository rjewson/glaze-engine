package glaze.engine.factories;

import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;

class BaseEntityFactory implements IEntityFactory {

	public var mapping(get, never):String;
	
	public function new() {
	}

	public function createEntity(data:Dynamic,engine:Engine) {
	}

	public function get_mapping():String {
		return "";
	}
    
    public function CreateEntityFromCSV<A:IComponent>(componentClass:Class<A>,csv:String):A {
    	var params = getCSVParams(csv);
        return cast Type.createInstance(componentClass,params);
    }

	public static function getCSVParams(csv:String):Array<Dynamic> {
		var params = csv.split(",");
		var parsedParams = new Array<Dynamic>();
		for (param in params) {
			var i = Std.parseInt(param);
			if (i!=null) {
				parsedParams.push(i);
				continue;
			}
			var f = Std.parseFloat(param);
			if (f!=null) {
 				parsedParams.push(f);
				continue;
			}
			parsedParams.push(param);
		}
		return parsedParams;
	}

}