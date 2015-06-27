package engine.ai.steering.behaviours;
import engine.ai.navigation.Node;
import engine.ai.steering.SteeringSettings;
import engine.dynamics.GameBody;
import physics.geometry.Vector2D;

/**
 * ...
 * @author rje
 */

class FollowPath1 extends Behavior
{

	public var path:Array<Vector2D>;
	public var seekDistSq : Float;
	
	var currentIndex:Int;
	
	public function new(path : Array<Vector2D>, seekDistSq : Float = 2048) {
		super(SteeringSettings.followPathWeight, SteeringSettings.followPathPriority);
		
		this.path = path;
		this.seekDistSq = seekDistSq;
		
		currentIndex = 0;
	}

	override public function calculate() : Vector2D {
		var d = path[ currentIndex ].distanceSqrd(agent.averageCenter) ;
		if ( d < seekDistSq) {
			currentIndex++;
			if (currentIndex == path.length) {
				steering.removeBehaviour(this);
				return new Vector2D();
			}
		}
		
		return Seek.calc(agent, path[currentIndex]);
	}
	
}