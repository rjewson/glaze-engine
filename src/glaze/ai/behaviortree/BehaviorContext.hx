package glaze.ai.behaviortree;

import glaze.ds.DynamicObject;
import glaze.eco.core.Entity;
import glaze.signals.Signal0;

class BehaviorContext 
{

    public var entity:Entity;
    public var data:DynamicObject<Dynamic>;
    public var event:Signal0;
    public var time:Float;

    public function new(entity:Entity) {
        this.entity = entity;
        this.time = 0;
        this.data = new DynamicObject<Dynamic>();
    }

}