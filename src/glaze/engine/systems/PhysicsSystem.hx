package glaze.engine.systems;

import glaze.engine.components.Physics;
import glaze.engine.components.Position;
import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.eco.core.System;
import glaze.eco.core.View;
import glaze.physics.collision.broadphase.BruteforceBroadphase;
import glaze.physics.collision.Intersect;
import glaze.physics.collision.Map;
import glaze.physics.PhysicsEngine;

class PhysicsSystem extends System {

    public var physicsEngine:PhysicsEngine;
    public var map:Map;

    public function new(map:Map) {
        super([Position,Physics]);
        this.map = map;
        initalizePhysicsEngine();
    }

    function initalizePhysicsEngine() {
        physicsEngine = new PhysicsEngine(60,new BruteforceBroadphase(map,new Intersect()));
    }

    override public function entityAdded(entity:Entity,component:IComponent) {
        //js.Lib.debug();
        var position = entity.getComponent(Position);
        var physics = entity.getComponent(Physics);
        //physics.body.position.copy(position.coords);
        physics.body.position = position.coords;
        physicsEngine.addBody(physics.body);
    }

    override public function entityRemoved(entity:Entity,component:IComponent) {
    }

    override public function update(timestamp:Float,delta:Float) {
        //js.Lib.debug();
        physicsEngine.update(delta);
        // for (entity in view.entities) {
        //     var position = entity.getComponent(Position);
        //     var physics = entity.getComponent(Physics);
        //     position.coords.copy(physics.body.position);
        //     //trace(position.coords);
        // }
        // trace("physics");
    }

}