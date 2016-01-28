package glaze.ai.navigation;
import glaze.geom.Vector2;

/**
 * ...
 * @author rje
 */

class Node 
{

	public var position:Vector2D;
	public var parent:Node;
	public var f:Float;
	public var g:Float;
	public var h:Float;
	
	public var links:Array<Edge>;
	
	public var walkable:Bool;
	
	public function new(x:Float,y:Float) 
	{
		position = new Vector2D(x,y);
		f = 0;
		g = 0;
		h = 0;
		
		links = new Array<Edge>();
	
		walkable = true;
		
	}
	
	public function reset():Void {
		parent = null;
		f = g = h = 0;
	}
	
	public function setG(o:Edge):Void{
		g = parent.g + o.distance;
	}
	
	public function setF(finish:Node):Void {
		setH(finish);
		f = g + h;
	}

	public function setH(finish:Node):Void {
		h = dist(finish);
	}
	
	public function dist(n:Node):Float {
		return position.distanceSqrd(n.position);
	}
	
	public function connect(n:Node){
		links.push(new Edge(n, dist(n)));
	}
	
}