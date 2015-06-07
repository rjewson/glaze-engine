package glaze.ai.behaviortree;

/**
 * A sequence handles behaviors in order and continues until one does not succeed
 */
class Sequence extends Composite
{

	override private function initialize(context:BehaviorContext)
	{
		_current = children.iterator();
		_currentBehavior = _current.next();
	}

	override private function update(context:BehaviorContext):BehaviorStatus
	{
		while (_currentBehavior != null)
		{
			var status = _currentBehavior.tick(context);

			// if the child fails, or keeps running, do the same.
			if (status != Success)
			{
				return status;
			}

			if (_current.hasNext())
			{
				_currentBehavior = _current.next();
			}
			else
			{
				break;
			}
		}
		return Success;
	}

	private var _current:Iterator<Behavior>;
	private var _currentBehavior:Behavior;

}
