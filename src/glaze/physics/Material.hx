package glaze.physics;

import glaze.physics.Material;

/**
 * ...
 * @author rje
 */

class Material 
{   

	public static var NORMAL:Material = new Material(1,0.3,0.1);
	public static var LIGHTMETAL:Material = new Material(1.6,0.3,0.1);
	public static var ROCK:Material   = new Material(2,0.2,0.1);

    public var density : Float;
    public var elasticity : Float;
    public var friction : Float;

    public function new(density : Float = 1, elasticity : Float = 0.3, friction : Float = 0.1) {
        this.density = density;
        this.elasticity = elasticity;
        this.friction = friction;
    }
    
}