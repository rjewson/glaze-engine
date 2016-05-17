package glaze.ai.steering.behaviors;

import glaze.ai.steering.behaviors.Feeler;
import glaze.ai.steering.SteeringSettings;
import glaze.geom.Vector2;
import glaze.physics.Body;
import glaze.physics.collision.Map;

/**
 * ...
 * @author rje
 */

class WallAvoidance extends Behavior {

	public var feelerLength:Float;
	
	var feelers:Array<Feeler>;
	
	var ptv1:Vector2;
	var ptv2:Vector2;  
	
	var lastPos:Vector2;
		
	var pA:Vector2 = new Vector2();
	var pB:Vector2 = new Vector2();

	var top:Vector2 	= new Vector2(0,-1);
	var right:Vector2 	= new Vector2(1,0);
	var bottom:Vector2 	= new Vector2(0,1);
	var left:Vector2 	= new Vector2(-1,0);
	var searchAABB:glaze.geom.AABB2 = new glaze.geom.AABB2();
	var map:Map;

	var closestFeeler:Feeler = null;
	var closestDist:Float = Math.POSITIVE_INFINITY;

	public function new(map:Map,feelerLength:Float) {
		super(SteeringSettings.wallAvoidanceWeight, SteeringSettings.wallAvoidancePriority);
		this.map = map;
		this.feelerLength = feelerLength;
		
		ptv1 = new Vector2();
		ptv2 = new Vector2();
		
		feelers = new Array<Feeler>();
		feelers.push(new Feeler(0,feelerLength));
		feelers.push(new Feeler(glaze.util.Maths.toRad(-40),feelerLength * 0.5));
		feelers.push(new Feeler(glaze.util.Maths.toRad(40), feelerLength * 0.5));
		
		lastPos = new Vector2();
		
	}

	function checkAABB(aabb:glaze.geom.AABB) {
		for (feeler in feelers) {
			//top
			pA.setTo(aabb.l,aabb.t);
			pB.setTo(aabb.r,aabb.t);
			feeler.TestSegment(pA, pB, top);	
			//right
			pA.setTo(aabb.r,aabb.b);
			feeler.TestSegment(pB, pA, right);	
			//bottom
			pB.setTo(aabb.l,aabb.b);
			feeler.TestSegment(pA, pB, bottom);	
			//left
			pA.setTo(aabb.l,aabb.t);
			feeler.TestSegment(pB, pA, left);	

			if (feeler.distToClosestIP < closestDist) {
				closestDist = feeler.distToClosestIP;
				closestFeeler = feeler;
			}

		}
	}

	// function check(shape:GeometricShape, pos:Vector2):Void {

	// 	var tile:Tile = cast shape;
		
	// 	var tv1 : Vector2 = tile.transformedVertices[0];
	// 	var tv2 : Vector2 = tile.transformedVertices[1];
				
	// 	for (i in 0...tile.vertexCount) {
	// 		ptv1.x = tv1.x + pos.x;
	// 		ptv1.y = tv1.y + pos.y;
	// 		ptv2.x = tv2.x + pos.x;
	// 		ptv2.y = tv2.y + pos.y;

	// 		for (feeler in feelers) {
				
	// 			//if (feeler.dot(ta.n) > 0)
	// 			//	continue;
				
	// 			feeler.TestSegment(ptv1, ptv2, tile.transformedAxes[i].n);				

	// 		}
			
	// 		tv1 = tv2;
	// 		tv2 = tile.transformedVertices[(i + 2) % tile.vertexCount];
	// 	}		
	// }
	
	override public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {
						
		if (lastPos.distSqrd(agent.position) < 1)
			return;
		lastPos.copy(agent.position);

		var unit:Vector2 = agent.velocity.clone();
		unit.normalize();//GetVelocity().unit();

		for (feeler in feelers) {
			feeler.Reset(unit, agent.position);
		}

		closestFeeler = null;
		closestDist = Math.POSITIVE_INFINITY;

		searchAABB.reset();
		searchAABB.addPoint(agent.position.x,agent.position.y);
		searchAABB.addPoint(feelers[0].tip.x,feelers[0].tip.y);
		// searchAABB.expand(20);
		map.iterateCells(searchAABB,checkAABB);

		if (closestFeeler != null)
			closestFeeler.CalculateForce(result);

	}
	
}