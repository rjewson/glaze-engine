package glaze.ai.behaviortree.leaf;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;


class SetContextData extends Behavior
{

	public function new()
	{
		super();
	}

	override private function initialize(context:BehaviorContext) {
	}

	override public function update(context:BehaviorContext):BehaviorStatus {
		return Success;
	}


}
