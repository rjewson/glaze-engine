package glaze.ai.behaviortree;

/**
 * A repeat node will rerun the same behavior up to a certain number of iterations
 */
class Repeat extends Decorator
{

	/**
	 * The number of times to repeat the behavior action
	 */
	public var count:Int = 0;

	/**
	 * Repeat constructor
	 * @param child The behavior to repeat
	 * @param count The number of times to repeat
	 */
	public function new(child:Behavior, count:Int = 0)
	{
		super(child);
		this.count = count;
	}

	override private function initialize(context:BehaviorContext)
	{
		_counter = 0;
	}

	override private function update(context:BehaviorContext):BehaviorStatus
	{
		while(true)
		{
			switch (child.tick(context))
			{
				case Running:
					break;
				case Failure:
					return Failure;
				default:
					if (++_counter == count) return Success;
			}
			child.reset();
		}
		return Invalid;
	}

	private var _counter:Int = 0;

}
