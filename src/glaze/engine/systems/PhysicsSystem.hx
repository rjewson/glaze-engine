package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Physics;
import glaze.engine.components.Position;
import glaze.physics.PhysicsEngine;
import glaze.physics.collision.Intersect;
import glaze.physics.collision.Map;
import glaze.physics.collision.broadphase.BruteforceBroadphase;

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

    override public function entityAdded(entity:Entity) {
        var position = entity.getComponent(Position);
        var physics = entity.getComponent(Physics);
        physics.body.position = position.coords;
        physicsEngine.addBody(physics.body);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        physicsEngine.update(delta);
    }

}