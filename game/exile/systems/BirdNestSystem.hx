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
        super([Position,BirdNest,Active]);
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

			if (nest.intervalDelay.tick(delta)) {
				var target = evaluateTargets(entity);
				if (target!=null) {
					releaseBird(entity);
				}
			// 	var e = exile.util.CombatUtils.searchSortAndFilter(entity.getComponent(Position).coords,200,entity).entities.head;
			// 	while (e!=null) {
			// 		trace(e.entity.name);
			// 		if (nest.birds.length==0) {
			// 			var bird = exile.entities.creatures.BirdFactory.create(engine,entity.getComponent(Position).clone(),new Position(30*16,40*16));
			// 			nest.birds.push(bird);
			// 		}				
			// 		e = e.next;
			// 	}
			}

			if (nest.triggered) {
				// trace("in");
				nest.triggered = false;
				

			} else {
				// trace("out");
			}
			// if (beehive.bees.length<beehive.maxBees) {
			// 	if (glaze.util.Random.RandomBoolean(0.01)) {
			// 		var newBee = BeeFactory.create(engine,entity.getComponent(Position).clone());
			// 		newBee.parent = entity;
			// 		newBee.messages.add(beeDestroyed);
			// 		beehive.bees.push(newBee);
			// 	}
			// }
		}
	}

    public function triggerCallback(a:BFProxy,b:BFProxy,contact:Contact) {        
    	// trace("hit");
    	a.entity.parent.getComponent(BirdNest).triggered = true;
	}

	public function evaluateTargets(entity:Entity):Entity {

		var entities = glaze.util.CombatUtils.searchSortAndFilter(entity.getComponent(Position).coords,200,entity,glaze.util.CombatUtils.EntityFilterOptions.ALL).entities;
		var target = entities.head;
		// trace("eval targets");
		// if (entities.length>0)
		// 	js.Lib.debug();

		for (i in entities) { 
			// js.Lib.debug(); 
			trace('evel tagets = ${i.entity.name}');
		}

		while (target!=null) {
			trace(target.entity.name);
			if (target!=null)
				return target.entity;
			target = target.next;
		}
		return null;
	}

	public function releaseBird(entity:Entity) {
		var nest = entity.getComponent(BirdNest);
		if (nest.birds.length==0) {
			var bird = exile.entities.creatures.BirdFactory.create(engine,entity.getComponent(Position).clone(),new Position(30*16,40*16));
			nest.birds.push(bird);
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