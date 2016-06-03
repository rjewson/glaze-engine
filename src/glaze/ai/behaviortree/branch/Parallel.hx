package glaze.ai.behaviortree.branch;

import glaze.ai.behaviortree.Composite;
import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;

/**
 * List of policy types
 */
enum Policy
{
	RequireOne; /** only requires one behavior to succeed or fail **/
	RequireAll; /** requires all behaviors to succeed or fail **/
}

/**
 * A parallel node processes all child behaviors at once and returns based on the policies provided
 */
class Parallel extends Composite
{

	private var _successPolicy:Policy;
	private var _failurePolicy:Policy;

	/**
	 * Parallel constructor
	 * @param success The policy for success
	 * @param failure The policy for failure
	 */
	public function new(success:Policy, failure:Policy)
	{
		super();
		_successPolicy = success;
		_failurePolicy = failure;
	}

	override private function initialize(context:BehaviorContext)
	{
	}


	override private function update(context:BehaviorContext):BehaviorStatus
	{
		var successCount:Int = 0,
			failureCount:Int = 0;

		for (child in children)
		{
			trace("check term");
			if (!child.terminated)
			{
				child.tick(context);
			}

			switch (child.status)
			{
				case Success:
					successCount += 1;
					if (_successPolicy == RequireOne)
					{
						return Success;
					}
				case Failure:
					failureCount += 1;
					if (_failurePolicy == RequireOne)
					{
						return Failure;
					}
				default:
			}
		}

		if (_failurePolicy == RequireAll && failureCount == children.length)
		{
			trace("Parallel Failed");
			return Failure;
		}

		if (_successPolicy == RequireAll && successCount == children.length)
		{
			trace("Parallel Success");
			return Success;
		}

		return Running;
	}

	override private function terminate(status:BehaviorStatus)
	{
		for (child in children)
		{
			if (child.running)
			{
				child.abort();
			}
			child.reset();
		}
	}

}
