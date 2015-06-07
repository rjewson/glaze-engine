package glaze.physics;

/**
 * ...
 * @author rje
 */

class Material 
{   
    public var density : Float;
    public var elasticity : Float;
    public var friction : Float;

    public function new(density : Float = 1, elasticity : Float = 0.3, friction : Float = 0.1) {
        this.density = density;
        this.elasticity = elasticity;
        this.friction = friction;
    }
    
}