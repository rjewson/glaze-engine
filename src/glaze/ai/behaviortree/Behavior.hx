package glaze.ai.behaviortree;

class Behavior
{

	/**
	 * The current status of the behavior
	 */
	private var status(default, null):BehaviorStatus;

	/**
	 * Behavior constructor
	 */
	public function new()
	{
		status = Invalid;
	}

	/**
	 * Called when the behavior initializes (should be overridden in sub classes)
	 */
	private function initialize(context:BehaviorContext):Void { }
	/**
	 * Called when the behavior terminates (should be overridden in sub classes)
	 * @param status the status causing termination
	 */
	private function terminate(status:BehaviorStatus):Void { }
	/**
	 * Called when the behavior updates (should be overridden in sub classes)
	 * @return The behavior status from that update
	 */
	private function update(context:BehaviorContext):BehaviorStatus { return status; }

	/**
	 * Specifies if the behavior is terminated
	 */
	public var terminated(get, never):Bool;
	private inline function get_terminated():Bool
	{
		return status == Success || status == Failure;
	}

	/**
	 * Specifies if the behavior is running
	 */
	public var running(get, never):Bool;
	private inline function get_running():Bool
	{
		return status == Running;
	}

	/**
	 * Resets the behavior
	 */
	public function reset():Void
	{
		status = Invalid;
	}

	/**
	 * Aborts the behavior
	 */
	public function abort():Void
	{
		terminate(Aborted);
		status = Aborted;
	}

	/**
	 * Advances the behavior logic (initializes, updates, and terminates when necessary)
	 * @return The behavior status
	 */
	public function tick(context:BehaviorContext):BehaviorStatus
	{
		if (status != Running)
		{
			initialize(context);
		}

		status = update(context);

		if (status != Running)
		{
			terminate(status);
		}

		return status;
	}

}
