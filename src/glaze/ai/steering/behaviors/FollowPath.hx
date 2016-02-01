package glaze.ai.steering.behaviors;

import glaze.ai.navigation.Node;
import glaze.ai.steering.behaviors.Seek;
import glaze.geom.Vector2;
import glaze.physics.Body;

class FollowPath extends Behavior
{

	public var path:Array<Node>;
	public var seekDistSq : Float;
	
	var currentIndex:Int;
	
	public function new(path : Array<Node>, seekDistSq : Float = 256) {
		super(SteeringSettings.followPathWeight, SteeringSettings.followPathPriority);
		
		this.path = path;
		this.seekDistSq = seekDistSq;
		
		currentIndex = 0;
	}

	override public function calculate(agent:Body,result:Vector2) {
		if (currentIndex==path.length)
			return;
		trace(currentIndex);
		if (!Seek.calc(agent,result,path[currentIndex].position,seekDistSq)) {
			currentIndex++;
		}
		// var d = path[ currentIndex ].distanceSqrd(agent.averageCenter) ;
		// if ( d < seekDistSq) {
		// 	currentIndex++;
		// 	if (currentIndex == path.length) {
		// 		steering.removeBehaviour(this);
		// 		return new Vector2();
		// 	}
		// }
		
		// return Seek.calc(agent, path[currentIndex]);
	}
	
}