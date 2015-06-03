package glaze.engine.components;

import glaze.geom.Vector2;
import glaze.eco.core.IComponent;
import glaze.render.display.DisplayObject;

class Display implements IComponent {

    public var textureID:String;
    public var displayObject:DisplayObject;

    public function new(textureID:String) {
        this.textureID = textureID;
    }

}