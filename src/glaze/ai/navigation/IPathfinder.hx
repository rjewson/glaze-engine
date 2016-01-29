package glaze.ai.navigation;

interface IPathfinder 
{

	function FindPath(nodes:Array<Node>, start:Node, finish:Node):Array<Node>;
	
}