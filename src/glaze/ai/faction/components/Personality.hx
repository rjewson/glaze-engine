package glaze.ai.faction.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;

class Personality implements IComponent {
	
	public var faction:Faction;

	public function applyDamage(sourceEntity:Entity,damageType:String,damageAmount:Float) {
		trace('Damage from ${sourceEntity.name}');
	}

}