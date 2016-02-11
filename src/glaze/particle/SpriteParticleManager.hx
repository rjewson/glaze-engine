
package glaze.particle;

import glaze.geom.Vector2;
import glaze.particle.ParticleFrame;
import glaze.particle.SpriteParticleSequence;
import haxe.ds.StringMap;

class SpriteParticleManager
{

	public var frames:StringMap<ParticleFrame>;
    public var sequences:StringMap<SpriteParticleSequence>;
    public var sequencesList:Array<SpriteParticleSequence>;
    var count:Int = 0;

    public function new() {
    	frames = new StringMap<ParticleFrame>();
    	sequences = new StringMap<SpriteParticleSequence>();
        sequencesList = new Array<SpriteParticleSequence>();
    }

    public function ParseSequenceJSON(sequenceConfig:Dynamic) {  
        if (!Std.is(sequenceConfig, String)) 
            return;

        var sequenceData = haxe.Json.parse(sequenceConfig);

        var fields = Reflect.fields(sequenceData);
        for (prop in fields) {

        	trace(prop);
        	var pattern:JSONParticleSequencePattern = Reflect.field(sequenceData, prop);
        	var seq = fromParticleSequencePattern(prop,pattern);
        	sequences.set(prop,seq);
            sequencesList[seq.id] = seq;
        }
        // js.Lib.debug();

    }

    public function ParseTexturePackerJSON(textureConfig:Dynamic) {   
        if (!Std.is(textureConfig, String)) 
            return;

        var textureData = haxe.Json.parse(textureConfig);
        // var meta = Reflect.fields(textureData.meta);

        var meta = Reflect.field(textureData,"meta");
        var width = meta.size.w;
        var height = meta.size.h;

        var fields = Reflect.fields(textureData.frames);
        for (prop in fields) {

            var frame:glaze.render.texture.TextureManager.TexturePackerItem = Reflect.field(textureData.frames, prop);

            var pF = new ParticleFrame(frame.frame.x/width,frame.frame.y/height,frame.frame.w/width,frame.frame.h/height);

            frames.set(prop,pF);

        }
    }

    public function fromParticleSequencePattern(name:String,pattern:JSONParticleSequencePattern):SpriteParticleSequence {
    	var list = new Array<ParticleFrame>();
    	for (i in pattern.start ... pattern.end+1) {
    		var frame = frames.get(StringTools.replace(pattern.pattern,"{x}",""+i));
    		list.push(frame);
    	}
        var sequence = new SpriteParticleSequence(count++,name,list,pattern.fps);
        return sequence;
    }

}