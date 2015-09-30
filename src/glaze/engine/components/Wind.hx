package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class Wind implements IComponent {

	public var particleCount:Float;
	public var incPerFrame:Float;
	public var particlePerUnitPerFrame:Float;

    public function new(particlePerUnitPerFrame:Float) {
    	this.particlePerUnitPerFrame = particlePerUnitPerFrame;
    	particleCount = .0;
    	incPerFrame = .0;
    }

}