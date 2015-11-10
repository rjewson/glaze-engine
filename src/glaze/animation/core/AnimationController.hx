class AnimationController {

	public var name:String;
	public var frameRate:Float;
	public var frames:Array<String>;
	public var loop:Bool;

	public var isPlaying:Bool;
	public var frameIndex:Int;
	public var accumulator:Float;
	public var isFinished:Bool;

	var delay:Float;

	public function new(name:String,frameRate:Float,frames:Array<String>,loop:Bool) {
		this.name = name;
		this.frameRate = frameRate;
		this.frames = frames;
		this.loop = loop;
	}

	public function play() {
		isPlaying = true;
		isFinished = false;
		delay = 1000/frameRate;
		accumulator = delay;
		frameIndex = 0;
	}

	public function update(delta:Float) {
		accumulator-=delta;
		if (accumulator<=0) {
			frameIndex++;
			if (frameIndex>=frames.length) {
				if (!loop)
					stop();
				else
					frameIndex = 0;
			}
			accumulator = delay;
		}
	}

	public function stop() {
		isFinished = true;
		isPlaying = false;
	}

}