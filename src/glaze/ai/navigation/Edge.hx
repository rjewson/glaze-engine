package glaze.ai.navigation;

/**
 * ...
 * @author rje
 */

class Edge 
{

	public var node:Node;
	public var distance:Float;
	
	public function new(node:Node,distance:Float) 
	{
		this.node = node;
		this.distance = distance;
	}
	
}