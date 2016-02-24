package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.geom.Vector2;
import glaze.eco.core.IComponent;
import glaze.render.display.Sprite;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class TileDisplay implements IComponent {

    public var tileFrameId(default, set):String;
    public var onChange:Void->Void;

    public function new(tileFrameId:String) {
    	this.tileFrameId = tileFrameId;
    }

    private function set_tileFrameId(value:String):String {
    	tileFrameId = value;
    	if (onChange!=null) {
            onChange();
    	}
        return value;
    }
 
}