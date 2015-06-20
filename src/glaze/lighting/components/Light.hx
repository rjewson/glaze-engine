package glaze.lighting.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Light implements IComponent {
    
    public var range:Float;

    public var attenuation:Int;
    
    public var intensity:Float;

    public var flicker:Float;

}