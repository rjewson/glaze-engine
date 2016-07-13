package glaze.ai.behaviortree;

/**
 * A composite is a collection of behaviors
 */
class Composite extends Behavior
{

	private var children:Array<Behavior>;

	public function new() {
		super();
		children = new Array<Behavior>();
	}

	override public function addChild(child:Behavior) {
		super.addChild(child);
		children.push(child);
	}

	override public function removeChild(child:Behavior) {
		super.removeChild(child);
		children.remove(child);
	}

	public function removeAll() {
		while (children.length>0)
			children.pop();
	}

	override public function reset():Void {
		for (child in children)
			child.reset();
	}


}
