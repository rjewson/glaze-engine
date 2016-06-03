package glaze.ai.behaviortree;

/**
 * A decorator contains a single behavior
 */
class Decorator extends Behavior
{

	private var child:Behavior;

	public function new() {
		super();
		addChild(child);
	}

	override public function addChild(child:Behavior) {
		this.child = child;
	}

}