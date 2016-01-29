package glaze.util;
import glaze.geom.Vector2;

class Geometry 
{

	public static function lineIntersection(A:Vector2, B:Vector2, C:Vector2, D:Vector2, point:Vector2):Float
	{
		var rTop:Float = (A.y-C.y)*(D.x-C.x)-(A.x-C.x)*(D.y-C.y);
		var sTop:Float = (A.y-C.y)*(B.x-A.x)-(A.x-C.x)*(B.y-A.y);
		var rBot:Float = (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);			
		var sBot:Float = (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);
		
		if( (rBot == 0) || (sBot == 0) ){
			//lines are parallel
			return -1;
		}
		
		var r:Float = rTop/rBot;
		var s:Float = sTop/sBot;
		
		if(( r > 0 ) && ( r < 1 ) && ( s >0 ) && ( s < 1 )) {	
			//A + r * (B - A)
			point.x = A.x + r * ( B.x - A.x );
			point.y = A.y + r * ( B.y - A.y );
			
			return A.distSqrd(B) * r;
		} 
		
		return 0;
	}
	
}