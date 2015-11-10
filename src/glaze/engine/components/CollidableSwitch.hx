package glaze.engine.components;

import glaze.eco.core.IComponent;

class CollidableSwitch implements IComponent {

    public var delay:Float;
    public var lastTrigger:Float;
    public var triggerChannels:Array<String>;

    public function new(delay:Float,triggerChannels:Array<String>) {
        this.delay = delay;
        this.triggerChannels = triggerChannels;
        this.lastTrigger = -this.delay;
    }

    public function trigger(timestamp:Float):Bool {
    	if (timestamp-lastTrigger<delay)
    		return false;
    	lastTrigger = timestamp;
    	return true;
    }

}