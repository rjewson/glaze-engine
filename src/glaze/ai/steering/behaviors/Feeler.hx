package engine.ai.steering.behaviours;
import physics.geometry.GeometricShape;
import physics.geometry.Vector2D;
import util.Geometry;

/**
 * ...
 * @author rje
 */

class Feeler 
{

	public var base:Vector2D;
	public var tip:Vector2D;
	
	public var length:Float;
	public var angle:Float;
	
	public var distToClosestIP:Float;

	public var closestIP:Vector2D;
	var ip:Vector2D;
	
	var normal:Vector2D;
	
	public function new(angle:Float, length:Float ) 
	{
		this.angle = angle;
		this.length = length;
		
		base = new Vector2D();
		tip = new Vector2D();
		
		closestIP = new Vector2D();
		ip = new Vector2D();
	}
	
	public function Reset(unitDirection:Vector2D, position:Vector2D):Void {
		distToClosestIP = Math.POSITIVE_INFINITY;
		tip.copy(unitDirection);
		base.copy(position);
		if (angle != 0)
			tip.rotateEquals(angle);
		tip.multEquals(length);
		tip.plusEquals(base);
	}
	
	public function TestSegment(a:Vector2D, b:Vector2D, normal:Vector2D):Void {
		var distToThisIP = Geometry.lineIntersection(base, tip, a, b, ip);
		if ( distToThisIP > 0 && distToThisIP < distToClosestIP ) {	
			distToClosestIP = distToThisIP;
			closestIP.copy(ip);
			this.normal = normal;
		}
	}
	
	public function CalculateForce(force:Vector2D):Void {
		if (distToClosestIP != Math.POSITIVE_INFINITY) {
			var sf =  normal.mult( tip.minus( closestIP ).length() );
			force.plusEquals(sf);
		}
	}
	
}