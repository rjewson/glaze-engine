package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.engine.core.EngineLifecycle;

class Health implements IComponent {
    
	public var maxHealth:Float;
	public var currentHealth:Float;
	public var recoveryPerSecond:Float;
	public var recoveryPerMs:Float;

	public var onNoHealth:Entity->Void;

	// public var stateOnNoHealth:String = EngineLifecycle.DESTROY;

	public function new(maxHealth:Float,currentHealth:Float,recoveryPerSecond:Float,onNoHealth:Entity->Void):Void {
	    this.maxHealth = maxHealth;
	    this.currentHealth = currentHealth;
	    this.recoveryPerSecond = recoveryPerSecond;
	    this.recoveryPerMs = recoveryPerSecond/1000;
	    this.onNoHealth = onNoHealth;
	}

	public function applyDamage(damageAmount:Float) {
		currentHealth-=damageAmount;
	}

	public inline function isDead():Bool {
		return currentHealth<=0;
	}

}