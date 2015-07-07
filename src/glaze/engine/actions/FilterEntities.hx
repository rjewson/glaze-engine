package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.ds.EntityCollection;
import glaze.ds.EntityCollectionItem;

class FilterEntities extends Behavior {

    var entityCollection:EntityCollection;
    var filters:Array<ECIFilter>;

    public function new(filters:Array<ECIFilter>) {
        super();
        this.filters = filters;
    }

    override private function initialize(context:BehaviorContext):Void {
        entityCollection = untyped context.data.ec;
    }

    override private function update(context:BehaviorContext):BehaviorStatus {
        for (filter in filters) {
            if (entityCollection.length==0) break;
            entityCollection.filter(filter);
        }
        trace("final result="+entityCollection.length);
        return Success;
    }

}