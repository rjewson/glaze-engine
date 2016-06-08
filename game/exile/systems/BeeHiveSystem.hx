package exile.systems;

import exile.components.BeeHive;
import exile.entities.creatures.BeeFactory;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.Display;
import glaze.engine.components.Position;
import glaze.engine.components.Viewable;
import glaze.physics.components.PhysicsCollision;

class BeeHiveSystem extends System {
	
    public function new() {
        super([BeeHive,Viewable,Active]);
    }

    override public function entityAdded(entity:Entity) {
	}

	override public function entityRemoved(entity:Entity) {
		var beehive = entity.getComponent(BeeHive);
		for (bee in beehive.bees) {
			bee.destroy();
		}
	}

	override public function update(timestamp:Float,delta:Float) {
		// return;
		for (entity in view.entities) {
			var beehive = entity.getComponent(BeeHive);
			if (beehive.bees.length<beehive.maxBees) {
				if (glaze.util.Random.RandomBoolean(0.01)) {
					var newBee = BeeFactory.create(engine,entity.getComponent(Position).clone());
					newBee.parent = entity;
					newBee.messages.add(onDestroy);
					beehive.bees.push(newBee);
				}
			}
		}
	}

	function onDestroy(entity:Entity,channel:String,data:Dynamic) {
		if (channel==Entity.DESTROY) {
			if (entity.parent!=null) {
				var beeHive = entity.parent.getComponent(BeeHive);
				beeHive.bees.remove(entity);
			}
		}
	}

}