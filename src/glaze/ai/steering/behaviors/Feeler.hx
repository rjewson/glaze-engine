package glaze.ai.steering.behaviors;

import glaze.geom.Vector2;

/**
 * ...
 * @author rje
 */

class Feeler 
{

	public var base:Vector2;
	public var tip:Vector2;
	
	public var length:Float;
	public var angle:Float;
	
	public var distToClosestIP:Float;

	public var closestIP:Vector2;
	var ip:Vector2;
	
	var normal:Vector2;
	
	public function new(angle:Float, length:Float ) 
	{
		this.angle = angle;
		this.length = length;
		
		base = new Vector2();
		tip = new Vector2();
		
		closestIP = new Vector2();
		ip = new Vector2();
		normal = new Vector2();
	}
	
	public function Reset(unitDirection:Vector2, position:Vector2):Void {
		distToClosestIP = Math.POSITIVE_INFINITY;
		tip.copy(unitDirection);
		base.copy(position);
		if (angle != 0) {
			var a = Math.atan2(unitDirection.y,unitDirection.x);
			a+=angle;
			tip.x = Math.cos(a);
  			tip.y = Math.sin(a);
  		}
		tip.multEquals(length);
		tip.plusEquals(base);
		
		//glaze.debug.DebugEngine.DrawParticle(tip.x,tip.y,4,255,0,0);

	}
	
	public function TestSegment(a:Vector2, b:Vector2, normal:Vector2):Void {
		var distToThisIP = glaze.util.Geometry.lineIntersection(base, tip, a, b, ip);
		if ( distToThisIP > 0 && distToThisIP < distToClosestIP ) {	
			distToClosestIP = distToThisIP;
			closestIP.copy(ip);
			this.normal.copy(normal);
		}
	}
	
	public function CalculateForce(force:Vector2):Void {
		if (distToClosestIP != Math.POSITIVE_INFINITY) {
			//glaze.debug.DebugEngine.DrawParticle(closestIP.x,closestIP.y,4,255,255,255);
			// var sf =  normal.mult( tip.minus( closestIP ).length() );
			var sf = tip.clone();
			sf.minusEquals(closestIP);
			normal.multEquals(sf.length());
			force.plusEquals(normal);
		}
	}
	
}