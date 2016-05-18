package glaze.ai.steering.behaviors;

import glaze.ai.navigation.Node;
import glaze.ai.steering.behaviors.Seek;
import glaze.geom.Vector2;
import glaze.physics.Body;

class FollowPath extends Behavior
{

	public var path:Array<Node>;
	public var loop:Bool;
	public var seekDist : Float;
	
	var currentIndex:Int;
	
	public function new(path : Array<Node>, loop:Bool=false, seekDist : Float = 32) {
		super(SteeringSettings.followPathWeight, SteeringSettings.followPathPriority);
		
		this.path = path;
		this.loop = loop;
		this.seekDist = seekDist;
		
		currentIndex = 0;
	}

	override public function calculate(agent:Body,params:SteeringAgentParameters,result:Vector2) {
		if (loop&&currentIndex==path.length)
			return;
		if (!Seek.calc(agent,params,result,path[currentIndex].position,seekDist)) {
			currentIndex++;
	}
	
}