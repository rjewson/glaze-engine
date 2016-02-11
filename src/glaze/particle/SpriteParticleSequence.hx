
package glaze.particle;

import glaze.geom.Vector2;
import glaze.particle.ParticleFrame;
import haxe.ds.StringMap;

typedef JSONParticleSequencePattern = {
    var fps:Int;
    var pattern:String;
    var start:Int;
    var end:Int;
}

class SpriteParticleSequence
{

    public var id:Int;
    public var name:String;
    public var sequence:Array<ParticleFrame>;
    public var fps:Float;
    public var len:Int;

    public function new(id:Int,name:String,sequence:Array<ParticleFrame>,fps:Float) {
        this.id = id;
        this.name = name;
        this.sequence = sequence;
        this.fps = fps;
        this.len = sequence.length;
    }

    public function ttl():Float {
        return (sequence.length / fps) * 1000;
    }

}