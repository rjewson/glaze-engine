package glaze.ai.behaviortree;

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

	override private function update(context:BehaviorContext):BehaviorStatus
	{
		var successCount:Int = 0,
			failureCount:Int = 0;

		for (child in children)
		{
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
			return Failure;
		}

		if (_successPolicy == RequireAll && successCount == children.length)
		{
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
		}
	}

	private var _successPolicy:Policy;
	private var _failurePolicy:Policy;

}
