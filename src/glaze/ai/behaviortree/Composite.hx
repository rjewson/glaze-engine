package glaze.ai.behaviortree;

/**
 * A composite is a collection of behaviors
 */
class Composite extends Behavior
{

	/**
	 * Composite constructor
	 */
	public function new()
	{
		super();
		children = new List<Behavior>();
	}

	/**
	 * Adds a child behavior to the composite
	 * @param child The behavior to add
	 */
	public inline function addChild(child:Behavior)
	{
		children.add(child);
	}

	/**
	 * Removes a child behavior from the composite
	 * @param child The behavior to remove
	 */
	public inline function removeChild(child:Behavior)
	{
		children.remove(child);
	}

	/**
	 * Removes all children from the composite
	 */
	public inline function removeAll()
	{
		children.clear();
	}

	private var children:List<Behavior>;

}
