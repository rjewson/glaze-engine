package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.ds.EntityCollection;
import glaze.ds.EntityCollectionItem;

class SortEntities extends Behavior {

    var entityCollection:EntityCollection;
    var comparitor:ECIComp;

    public function new(comparitor:ECIComp) {
        super();
        this.comparitor = comparitor;
    }

    override private function initialize(context:BehaviorContext):Void {
        entityCollection = untyped context.data.ec;
    }

    override private function update(context:BehaviorContext):BehaviorStatus {
        entityCollection.entities.sort(comparitor);
        return Success;
    }

}