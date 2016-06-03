package glaze.engine.actions;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;
import glaze.engine.components.Position;
import glaze.geom.Vector2;

class FindTarget extends Behavior {

    public function new() {
        super();
    }

    override private function initialize(context:BehaviorContext):Void {
    }

    override private function update(context:BehaviorContext):BehaviorStatus { 
        var position = context.entity.getComponent(Position).coords;

        var entities = glaze.util.CombatUtils.searchSortAndFilter(position,300,context.entity,glaze.util.CombatUtils.EntityFilterOptions.ALL).entities;
        //Found something
        if (entities.head!=null) {
            var target:Vector2 = cast Reflect.field(context.data,"target");

            Reflect.setField(context.data,"target",entities.head.entity.getComponent(Position).coords);

            return Success;
        }

        return Failure;
    }

}