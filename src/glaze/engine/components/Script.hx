package glaze.engine.components;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.eco.core.IComponent;

class Script implements IComponent {
    
    public var behavior:Behavior;
    public var context:BehaviorContext;

    public function new(behavior:Behavior) {
        this.behavior = behavior;
    }

}