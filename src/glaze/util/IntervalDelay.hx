package glaze.util;

class IntervalDelay {

	public var current:Float;
	public var intervalTime:Float;
	public var intervals:Float;

	public function new(intervalTime:Float = 0)
	{
	    reset(intervalTime);
	}

	public function reset(intervalTime:Float = 0) {
		this.current = 0;
	    this.intervalTime = intervalTime;
	    this.intervals = 0;
	}

	public function tick(delta:Float):Bool {
		current+=delta;
		if (current>intervalTime) {
			current = 0;
			intervals++;
			return true;
		}
		return false;
	}

}