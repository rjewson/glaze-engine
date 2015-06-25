package glaze.engine.factories.tmx;

import glaze.eco.core.IComponent;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.engine.factories.BaseEntityFactory;
import glaze.tmx.TmxObject;

class TMXEntityFactory extends BaseEntityFactory {

	public var tmxObject:TmxObject;

	public function new() {	
		super();
	}

	public function setTmxObject(data:Dynamic) {
		tmxObject = cast data;
	}

	public static function getEmptyComponentArray() {
		return new Array<IComponent>();
	}

	public static function getPosition(tmxObject:TmxObject):Position {
	    return new Position(SCALE(tmxObject.x+tmxObject.width/2),SCALE(tmxObject.y+tmxObject.height/2));
	}

	public static function getExtents(tmxObject:TmxObject):Extents {
	    return new Extents(SCALE(tmxObject.width/2),SCALE(tmxObject.height/2));
	}

	public static function SCALE(v:Float):Float {
		return v*2;
	}

}