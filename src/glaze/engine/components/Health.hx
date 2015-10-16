package glaze.engine.components;

import glaze.eco.core.IComponent;

class Health implements IComponent {
    
	public var maxHealth:Float;
	public var currentHealth:Float;
	public var recoveryPerSecond:Float;
	public var recoveryPerMs:Float;
	public var onNoHealth:Void->Void;

	public function new(maxHealth:Float,currentHealth:Float,recoveryPerSecond:Float,onNoHealth:Void->Void):Void {
	    this.maxHealth = maxHealth;
	    this.currentHealth = currentHealth;
	    this.recoveryPerSecond = recoveryPerSecond;
	    this.recoveryPerMs = recoveryPerSecond/1000;
	    this.onNoHealth = onNoHealth;
	}

	public function applyDamage(damageAmount:Float) {
		currentHealth-=damageAmount;
		if (currentHealth<=0&&onNoHealth!=null)
			onNoHealth();
	}

}