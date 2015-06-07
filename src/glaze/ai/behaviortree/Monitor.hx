package glaze.ai.behaviortree;

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
		super(RequireOne, RequireOne);
	}

	/**
	 * Add a condition (processed first)
	 * @param condition The behavior to add
	 */
	public function addCondition(condition:Behavior)
	{
		children.push(condition);
	}

	/**
	 * Add an action (processed last)
	 * @param action The behavior to add
	 */
	public function addAction(action:Behavior)
	{
		children.add(action);
	}

}
