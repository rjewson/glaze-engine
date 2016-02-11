
package glaze.particle;

import glaze.geom.Vector2;

class ParticleFrame
{

	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;

    // public var invSize:Float;

    public function new(x:Float,y:Float,w:Float,h:Float) {
        this.x=x;
        this.y=y;
        this.w=w;
        this.h=h;
        // this.size = size;
        // this.invSize = 1/size;
    }

}