package glaze.ai.behaviortree;

/**
 * A decorator contains a single behavior
 */
class Decorator extends Behavior
{

	public function new(child:Behavior)
	{
		super();
		this.child = child;
	}

	private var child:Behavior;

}