package glaze.ai.behaviortree;

/**
 * An active selector
 */
class ActiveSelector extends Selector
{

	override private function initialize(context:BehaviorContext)
	{
		// get last iterator value
		_current = children.iterator();
		while (_current.hasNext())
		{
			_currentBehavior = _current.next();
		}
	}

	override private function update(context:BehaviorContext):BehaviorStatus
	{
		var previousBehavior:Behavior = _currentBehavior;

		super.initialize(context);
		var result = super.update(context);

		if (_currentBehavior != previousBehavior)
		{
			previousBehavior.terminate(Aborted);
		}

		return result;
	}

}
