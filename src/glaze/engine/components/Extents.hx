package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Extents implements IComponent {
    
    public var halfWidths:Vector2;
    public var offset:Vector2;

    public function new(width:Float,height:Float,offsetX:Float=0,offsetY:Float=0) {
        halfWidths = new Vector2(width,height);
        offset = new Vector2(offsetX,offsetY);
    }

}