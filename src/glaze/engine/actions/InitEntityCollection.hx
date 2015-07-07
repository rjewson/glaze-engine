package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.ds.EntityCollection;

class InitEntityCollection extends Behavior {

    var entityCollection:EntityCollection;

    public function new() {
        super();
    }

    override private function initialize(context:BehaviorContext):Void {
        if (entityCollection==null) {
            entityCollection = new EntityCollection();
            Reflect.setField(context.data,"ec",entityCollection);
        }
        entityCollection.clear();
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 
        return Success;
    }

}