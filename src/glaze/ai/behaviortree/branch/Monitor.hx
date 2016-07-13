package glaze.ai.behaviortree.branch;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;


/**
 * A monitor processes all behaviors and only requires one success or failure
 */
class Monitor extends Parallel
{

	/**
	 * Monitor constructor
	 */
	public function new()
	{
		super(RequireAll, RequireAll);
	}

}
