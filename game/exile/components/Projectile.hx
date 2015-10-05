package exile.components;

import glaze.eco.core.IComponent;
import haxe.ds.StringMap;

typedef ProjectileType = {
  var ttl:Float;
  var bounce:Int;
  var power:Float;
  var range:Float;
}

class Projectile implements IComponent {

	public static var PROJECTILE_TYPES:Dynamic<ProjectileType> = {
		"bullet":{ttl:1000,bounce:1,power:10,range:32},
		"powerbullet":{ttl:2000,bounce:3,power:30,range:64}
	};

	public function new(type:String) {
	    this.type = Reflect.getProperty(PROJECTILE_TYPES,type);//PROJECTILE_TYPES[type];
	}

	public var type:ProjectileType;
	public var age:Float;
	public var bounce:Int;

}