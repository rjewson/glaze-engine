package glaze.ai.behaviortree.leaf;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;


class Success extends Behavior
{

	var count:Int;
	var counter:Int;

	public function new(count:Int = 0)
	{
		super();
		this.count = count;
	}

	override private function initialize(context:BehaviorContext)
	{
		counter = count;
	}


	override public function update(context:BehaviorContext):BehaviorStatus
	{
		trace("Running Success Task "+counter);
		counter--;
		if (counter<0) {
			trace("...done");
			return Success;
		}
		return Running;
	}

	override private function terminate(status:BehaviorStatus) { 
		trace("terminated");
	}


}
