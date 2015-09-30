package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Position implements IComponent {
    
    public var coords:Vector2;
    public var prevCoords:Vector2;
    public var direction:Vector2;

    public function new(x:Float,y:Float) {
        coords = new Vector2(x,y);
        prevCoords = new Vector2(x,y);
        direction = new Vector2(1,1);
    }

    inline public function update(position:Vector2) {
    	prevCoords.copy(coords);
    	coords.copy(position);
    }

    public function clone():Position {
        var clone = new Position(this.coords.x,this.coords.y);
        clone.prevCoords.copy(this.prevCoords);
        clone.direction.copy(this.direction);
        return clone;
    }

}