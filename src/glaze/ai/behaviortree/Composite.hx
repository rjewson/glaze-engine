package glaze.ai.behaviortree;

/**
 * A composite is a collection of behaviors
 */
class Composite extends Behavior
{

	private var children:List<Behavior>;

	public function new() {
		super();
		children = new List<Behavior>();
	}

	override public function addChild(child:Behavior) {
		children.add(child);
	}

	override public function removeChild(child:Behavior) {
		children.remove(child);
	}

	public function removeAll() {
		children.clear();
	}

	override public function reset():Void {
		for (child in children)
			child.reset();
	}


}
