package glaze.engine.components;

import glaze.geom.Vector2;
import glaze.eco.core.IComponent;
import glaze.render.display.Sprite;

class Display implements IComponent {

    public var textureID:String;
    public var offset:Vector2;

    public var displayObject:Sprite;

    public var onChange:Display->Void;

    public function new(textureID:String,offset:Vector2=null) {
    	update(textureID,offset);
    }

    public function update(textureID:String,offset:Vector2=null) {
        this.textureID = textureID;
        if (offset!=null)
        	this.offset = offset;
        if (onChange!=null)
        	onChange(this);
    }
 
}