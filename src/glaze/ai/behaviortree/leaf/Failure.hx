package glaze.ai.behaviortree.leaf;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;


class Failure extends Behavior
{

	var count:Int;
	var counter:Int;

	public function new(count:Int = 0)
	{
		super();
		this.count = count;
		this.counter = count;
	}

	override private function initialize(context:BehaviorContext)
	{
		trace("Failure initialized");
	}


	override public function update(context:BehaviorContext):BehaviorStatus
	{
		trace("Running Failure Task "+counter);
		counter--;
		if (counter>0) {
			trace("..failing");
			return Failure;
		}
		return Success;
	}

	override private function terminate(status:BehaviorStatus) { 
		trace("Failure terminated");
	}


}
