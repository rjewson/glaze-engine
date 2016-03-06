package glaze.engine.components;

import glaze.eco.core.IComponent;
import glaze.geom.Vector2;

class ForceData {
	public var direction:Vector2;
	public var minForce:Float;
	public var maxForce:Float;
	public var minDuration:Float;
	public var maxDuration:Float;

	public function new(direction:Float,minForce:Float,maxForce:Float,minDuration:Float,maxDuration:Float):Void
	{
	    // this.direction = new Vector2(0,-1);
	    // this.direction.rotateEquals(direction);
	    this.direction = new Vector2();
	    this.direction.setUnitRotation(direction-90);
	    this.minForce = minForce;
	    this.maxForce = maxForce;
	    this.minDuration = minDuration;
	    this.maxDuration = maxDuration;
	}
}

class EnvironmentForce implements IComponent {

	public var data:Array<ForceData>;

	public var direction:Vector2 = new Vector2();
	public var power:Float = 0;
	public var ttl:Float = 0;

	public var currentIndex:Int;

    // public function new(direction:Vector2) {
    public function new(data:Array<ForceData>) {
    	// this.direction = direction;
    	// this.data = new Array<Float>();
    	this.data = data;
    }

}