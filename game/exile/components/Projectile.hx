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

	public function new(type:ProjectileType) {
	    this.type = type;
	}

	public var type:ProjectileType;
	public var age:Float;
	public var bounce:Int;

}