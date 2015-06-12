package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Position implements IComponent {
    
    public var coords:Vector2;
    public var prevCoords:Vector2;

    public function new(x:Float,y:Float) {
        coords = new Vector2(x,y);
        prevCoords = new Vector2(x,y);
    }

    public function update(position:Vector2) {
    	prevCoords.copy(coords);
    	coords.copy(position);
    }

}