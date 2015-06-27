package engine.ai.steering.behaviours;
import engine.ai.steering.SteeringSettings;
import engine.GameEngine;
import engine.utils.IDraw;
import physics.geometry.GeometricShape;
import worldEngine.tiles.Tile;
import worldEngine.tiles.TileFeature;
import worldEngine.World;
import physics.geometry.Axis;
import physics.geometry.Vector2D;
import util.Geometry;

/**
 * ...
 * @author rje
 */

class WallAvoidance extends Behavior {

	public var feelerLength:Float;
	
	var feelers:Array<Feeler>;
	
	var ptv1:Vector2D;
	var ptv2:Vector2D;
	
	var lastPos:Vector2D;
	
	var graphics:IDraw;
	
	public function new(feelerLength:Float) {
		super(SteeringSettings.wallAvoidanceWeight, SteeringSettings.wallAvoidancePriority);
		
		this.feelerLength = feelerLength;
		
		ptv1 = new Vector2D();
		ptv2 = new Vector2D();
		
		feelers = new Array<Feeler>();
		feelers.push(new Feeler(0,feelerLength));
		feelers.push(new Feeler(-40,feelerLength*0.5));
		feelers.push(new Feeler(40, feelerLength * 0.5));
		
		lastPos = new Vector2D();
		
#if debuggraphics
	graphics = GameEngine.instance.camera.debugDraw;
	graphics.penStyle(1, 0);
#end
		
	}

	function check(shape:GeometricShape, pos:Vector2D):Void {

		var tile:Tile = cast shape;
		
		var tv1 : Vector2D = tile.transformedVertices[0];
		var tv2 : Vector2D = tile.transformedVertices[1];
				
		for (i in 0...tile.vertexCount) {
			ptv1.x = tv1.x + pos.x;
			ptv1.y = tv1.y + pos.y;
			ptv2.x = tv2.x + pos.x;
			ptv2.y = tv2.y + pos.y;

			for (feeler in feelers) {
				
				//if (feeler.dot(ta.n) > 0)
				//	continue;
				
				feeler.TestSegment(ptv1, ptv2, tile.transformedAxes[i].n);
				
#if debuggraphics
graphics.penStyle(3, 0xFF0000);
graphics.movePenTo(ptv1.x,ptv1.y);
graphics.drawPenTo(ptv2.x,ptv2.y);
#end					

			}
			
			tv1 = tv2;
			tv2 = tile.transformedVertices[(i + 2) % tile.vertexCount];
		}		
	}
	
	override public function calculate() : Vector2D {
				
		var steeringForce:Vector2D = new Vector2D();
		
		if (lastPos.distanceSqrd(agent.averageCenter) < 1)
			return steeringForce;
		lastPos.copy(agent.averageCenter);
				
		var unit = agent.GetVelocity().unit();

		for (feeler in feelers) {
			feeler.Reset(unit, agent.averageCenter);
#if debuggraphics
	graphics.movePenTo(feeler.base.x,feeler.base.y);
	graphics.drawPenTo(feeler.tip.x, feeler.tip.y);
#end
		}
	
		GameEngine.instance.physicsEngine.ProcessShapes(agent.position, 1, check);

		var closestFeeler = null;
		var closestDist = Math.POSITIVE_INFINITY;
		for (feeler in feelers) {
			if (feeler.distToClosestIP < closestDist) {
				closestDist = feeler.distToClosestIP;
				closestFeeler = feeler;
			}
			//feeler.CalculateForce(steeringForce);
		}
		if (closestFeeler != null)
			closestFeeler.CalculateForce(steeringForce);
#if debuggraphics
	graphics.penStyle(1, 0x00FF00);
	graphics.movePenTo(agent.averageCenter.x,agent.averageCenter.y);
	graphics.drawPenTo(agent.averageCenter.x+steeringForce.x,agent.averageCenter.y+steeringForce.y);
#end	
		return steeringForce;
	}
	
}