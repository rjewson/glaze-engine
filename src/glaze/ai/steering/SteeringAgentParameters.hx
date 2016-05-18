package glaze.ai.steering;

import glaze.ai.steering.SteeringAgentParameters;

class SteeringAgentParameters {

	public static inline var default_scale:Float  					= 	.2;
	public static inline var heavy_scale:Float  					= 	5;
	public static inline var default_maxAcceleration:Float			=	100;
	public static inline var default_maxSteeringForcePerStep:Float	=	100;

	public static var DEFAULT_STEERING_PARAMS:SteeringAgentParameters = new SteeringAgentParameters(
		default_maxAcceleration*default_scale,
		default_maxSteeringForcePerStep*default_scale
	);

	public static var HEAVY_STEERING_PARAMS:SteeringAgentParameters = new SteeringAgentParameters(
		default_maxAcceleration*heavy_scale,
		default_maxSteeringForcePerStep*heavy_scale
	);

	public var maxAcceleration:Float;// = 100/5;
	public var maxSteeringForcePerStep:Float;// = 100/5;
	
	public function new( maxAcceleration:Float, maxSteeringForcePerStep:Float):Void {
		this.maxAcceleration = maxAcceleration;
		this.maxSteeringForcePerStep = maxSteeringForcePerStep;
	}


}