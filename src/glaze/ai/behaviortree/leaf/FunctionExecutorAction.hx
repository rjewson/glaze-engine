package glaze.ai.behaviortree.leaf;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;


/**
 * An action specifies a function to be called when updating
 */
class FunctionExecutorAction extends Behavior
{

	private var fn:BehaviorContext->BehaviorStatus;

	/**
	 * Action constructor
	 * @param action the callback method when this behavior runs
	 */
	public function new(fn:BehaviorContext->BehaviorStatus)
	{
		super();
		this.fn = fn;
	}

	override public function update(context:BehaviorContext):BehaviorStatus
	{
		return fn(context);
	}

}
