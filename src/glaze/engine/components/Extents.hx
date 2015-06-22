package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Extents implements IComponent {
    
    public var halfWidths:Vector2;
    public var isStatic:Bool;

    public function new(width:Float,height:Float) {
        halfWidths = new Vector2(width,height);
    }

}