package exile.systems;

import exile.components.BeeHive;
import exile.components.BirdNest;
import exile.entities.creatures.BeeFactory;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.Display;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Position;
import glaze.engine.components.Viewable;
import glaze.geom.Vector2;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;

class BirdNestSystem extends System {
	
    public function new() {
        super([Position,BirdNest,Viewable,Active]);
    }

    override public function entityAdded(entity:Entity) {

    	var nest = entity.getComponent(BirdNest);
    	var position = entity.getComponent(Position);

		nest.trigger = engine.createEntity([
            position,
            new Extents(nest.radius/2,nest.radius/2),
            new PhysicsCollision(true,null,[triggerCallback]),
            new Fixed(),
            new Active()
        ],"trigger");
		entity.addChildEntity(nest.trigger);
	}

	override public function entityRemoved(entity:Entity) {
	}

	override public function update(timestamp:Float,delta:Float) {

		for (entity in view.entities) {
			var nest = entity.getComponent(BirdNest);
// trace(nest.group.members.length);
			if (nest.intervalDelay.tick(delta)) {
				var target = evaluateTargets(entity);
				if (target!=null) {
					releaseBird(entity,target);
				}
			}

			if (nest.triggered) {
				nest.triggered = false;				
			} else {
			}
		}
	}

    public function triggerCallback(a:BFProxy,b:BFProxy,contact:Contact) {        
    	a.entity.parent.getComponent(BirdNest).triggered = true;
	}

	public function evaluateTargets(entity:Entity):Entity {

		var entities = glaze.util.CombatUtils.searchSortAndFilter(entity.getComponent(Position).coords,200,entity,glaze.util.CombatUtils.EntityFilterOptions.ALL).entities;
		var target = entities.head;
		// trace("eval targets");
		// if (entities.length>0)
		// 	js.Lib.debug();

		// for (i in entities) { 
			// js.Lib.debug(); 
			// trace('evel tagets = ${i.entity.name}');
		// }

		while (target!=null) {
			// trace(target.enticty.name);
			if (target!=null)
				return target.entity;
			target = target.next;
		}
		return null;
	}

	public function releaseBird(entity:Entity,target:Entity) {
		var nest = entity.getComponent(BirdNest);
		if (nest.group.hasCapacity()) {
		// if (nest.birds.length==0) {
			var bird = exile.entities.creatures.BirdFactory.create(
				engine,
				entity.getComponent(Position).clone(),
				entity.getComponent(Position),
				entity
   			);
   			nest.group.addMember(bird);
			// nest.birds.push(bird);
		}				
	}

	public function targetBird() {

	}

	public function untargetBird() {

	}

	public function returnBird() {

	}

	// function beeDestroyed(entity:Entity,channel:String,data:Dynamic) {
	// 	if (channel==Entity.DESTROY) {
	// 		if (entity.parent!=null) {
	// 			var beeHive = entity.parent.getComponent(BeeHive);
	// 			beeHive.bees.remove(entity);
	// 		}
	// 	}
	// }

}