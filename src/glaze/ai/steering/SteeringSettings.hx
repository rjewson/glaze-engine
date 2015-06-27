package glaze.ai.steering;

/**
 * ...
 * @author rje
 */

class SteeringSettings 
{

	// Arrive speed settings
	public static inline var speedTweaker:Float	=	.3;
	public static inline var arriveFast:Float		=	1;
	public static inline var arriveNormal:Float	=	3;
	public static inline var arriveSlow:Float		=	5;
	
	// Wander Settings
	public static inline var wanderJitter:Float	=	300; // ( per second )
	public static inline var wanderDistance:Float	=	25;
	public static inline var wanderRadius:Float	=	15;
	
	// Probabilities - Used to determine the chance that the Prioritized Dithering ( fastest ) calculation method will run a behavior
	public static inline var separationProbability:Float			=	0.2;
	public static inline var cohesionProbability:Float			=	0.6;
	public static inline var alignmentProbability:Float			=	0.3;
	
	public static inline var dodgeProbability:Float			=	0.6;
	
	public static inline var seekProbability:Float				=	0.8;
	public static inline var fleeProbability:Float				=	0.6;
	public static inline var pursuitProbability:Float				=	0.8;
	public static inline var evadeProbability:Float				=	1;
	public static inline var offsetPursuitProbability:Float		=	0.8;
	public static inline var arriveProbability:Float				=	0.5;
	
	public static inline var obstacleAvoidanceProbability:Float	=	0.5;
	public static inline var wallAvoidanceProbability:Float		=	0.5;
	public static inline var hideProbability:Float				=	0.8;
	public static inline var followPathProbability:Float			=	0.7;
	
	public static inline var interposeProbability:Float			=	0.8;		
	public static inline var wanderProbability:Float				=	0.8;
	
	// Weights - Scalar to effect the weights of individual behaviors
	public static inline var  separationWeight:Float			=	1;
	public static inline var  alignmentWeight:Float			=	3;
	public static inline var  cohesionWeight:Float				=	2;
	
	public static inline var  dodgeWeight:Float				=	1;		
	
	public static inline var seekWeight:Float					=	1;
	public static inline var fleeWeight:Float					=	1;
	public static inline var pursuitWeight:Float				=	1;
	public static inline var evadeWeight:Float				=	0.1;
	public static inline var offsetPursuitWeight:Float		=	1;
	public static inline var arriveWeight:Float				=	1;
	
	public static inline var obstacleAvoidanceWeight:Float	=	10;
	public static inline var wallAvoidanceWeight:Float		=	10;
	public static inline var hideWeight:Float					=	1;
	public static inline var followPathWeight:Float			=	0.5;
	
	public static inline var interposeWeight:Float			=	1;		
	public static inline var wanderWeight:Float				=	1;
	
	// Priorities - Order in which behaviors are calculated ( lower Floats get calculated first )
	public static inline var wallAvoidancePriority:Float		=	10;
	public static inline var obstacleAvoidancePriority:Float	=	20;
	public static inline var evadePriority:Float				=	30;
	public static inline var hidePriority:Float				=	35;
	
	public static inline var seperationPriority:Float			=	40;
	public static inline var alignmentPriority:Float			=	50;
	public static inline var cohesionPriority:Float			=	60;
	
	public static inline var dodgePriority:Float				=	65;
	
	public static inline var seekPriority:Float				=	70;
	public static inline var fleePriority:Float				=	80;
	public static inline var arrivePriority:Float				=	90;
	public static inline var pursuitPriority:Float			=	100;
	public static inline var offsetPursuitPriority:Float		=	110;
	public static inline var interposePriority:Float			=	120;
	public static inline var followPathPriority:Float			=	130;
	public static inline var wanderPriority:Float				=	140;
	
}