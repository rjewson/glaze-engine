package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Position implements IComponent {
    
    public var coords:Vector2;

    public function new(x:Float,y:Float) {
        coords = new Vector2(x,y);
    }

}