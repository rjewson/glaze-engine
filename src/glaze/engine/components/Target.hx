package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.util.IntervalDelay;

class Target implements IComponent {
    
    public var targetEntity:Entity;
    public var validateCounter:IntervalDelay;

}