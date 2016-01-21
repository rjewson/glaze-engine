package glaze.engine.components;

import glaze.geom.Vector2;
import glaze.eco.core.IComponent;
import glaze.render.display.Sprite;
import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class Display implements IComponent {

    public var frame(default, set):Frame;
    public var frameList:FrameList;

    public var frameListId:String;
    public var initialFrameId:String;
    public var displayObject:Sprite;

    public function new(frameListId:String, initialFrameId:String=null) {
    	this.frameListId = frameListId;
    	this.initialFrameId = initialFrameId;
    }

    private function set_frame(value:Frame):Frame {
    	frame = value;
    	if (displayObject!=null) {
            frame.updateSprite(displayObject);
    	}
        return value;
    }

    public function setFrameId(id:String) {
    	this.frame = frameList.getFrame(id);
    }
 
}