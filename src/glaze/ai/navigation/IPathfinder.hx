package engine.ai.navigation;

/**
 * ...
 * @author rje
 */

interface IPathfinder 
{

	function FindPath(nodes:Array<Node>, start:Node, finish:Node):Array<Node>;
	
}