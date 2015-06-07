package glaze.ai.behaviortree;

/**
 * An action specifies a function to be called when updating
 */
class Action extends Behavior
{

	/**
	 * Action constructor
	 * @param action the callback method when this behavior runs
	 */
	public function new(action:String,actionContext:Dynamic)
	{
		super();
		this.action = action;
		this.actionContext = actionContext;
	}

	override public function update(context:BehaviorContext):BehaviorStatus
	{
		var f = Reflect.field(actionContext, action);
		if (Reflect.isFunction(f))
		{
			var result = Reflect.callMethod(actionContext, f, [context]);
			if (Std.is(result, BehaviorStatus))
			{
				return result;
			}
		}
		return Failure;
	}

	private var action:String;
	private var actionContext:Dynamic;

}
