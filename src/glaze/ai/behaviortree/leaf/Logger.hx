package glaze.ai.behaviortree.leaf;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;


class Logger extends Behavior
{

	var msg:String;

	public function new(msg:String)
	{
		super();
		this.msg = msg;
	}

	override private function initialize(context:BehaviorContext)
	{
		trace("init!");
		// reset();
	}

	override public function update(context:BehaviorContext):BehaviorStatus
	{
		trace(msg);
		return Success;
	}


}
