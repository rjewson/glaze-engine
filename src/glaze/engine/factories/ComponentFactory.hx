package glaze.engine.factories;

import glaze.eco.core.IComponent;

class ComponentFactory {
	
	public var map:Map<String,FactoryBinding>;

	public function new() {
		map = new Map<String,FactoryBinding>();
	}

	public function registerComponent(registeredName:String,cl:Class<IComponent>,factoryFunction:Class<IComponent>->String->IComponent) {
		map.set(registeredName,new FactoryBinding(cl,factoryFunction));
	}

	public function createComponent(name:String,data:String):IComponent {
		var binding = map.get(name);
		if (binding==null) 
			return null;
		return binding.factoryFunction(binding.cl,data);
	}

	public static function CSVFactory(cl:Class<IComponent>,csv:String):IComponent {
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
		return Type.createInstance(cl,parsedParams);
		// return null;
	}

}

class FactoryBinding {
	public var cl:Class<IComponent>;
	public var factoryFunction:Class<IComponent>->String->IComponent;
	public function new(cl:Class<IComponent>,factoryFunction:Class<IComponent>->String->IComponent) {
	    this.cl = cl;
	    this.factoryFunction = factoryFunction;
	}
}