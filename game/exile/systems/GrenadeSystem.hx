package exile.systems;

import exile.components.Grenade;
import glaze.ai.fsm.LightStackStateMachine;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.Age;
import glaze.engine.components.Destroy;
import glaze.engine.components.Display;
import glaze.engine.components.Health;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.State;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;
import glaze.util.StateChangeProxy;

class GrenadeSystem extends System {

    var broadphase:IBroadphase;
    var bfAreaQuery:glaze.util.BroadphaseAreaQuery;
    var scp:StateChangeProxy;

    public function new(broadphase:IBroadphase) {
        super([Grenade,PhysicsCollision,Health,State,Display,Active]);
        this.broadphase = broadphase;
        bfAreaQuery = new glaze.util.BroadphaseAreaQuery(broadphase);

        this.scp = new StateChangeProxy();
        this.scp.registerStateHandler("on",on);
        this.scp.registerStateHandler("off",off);
    }

    override public function entityAdded(entity:Entity) {    
        var state = entity.getComponent(State);
        scp.registerState(state);

    }

    override public function entityRemoved(entity:Entity) {
        var state = entity.getComponent(State);
        scp.unregisterState(state);

    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var grenade = entity.getComponent(Grenade);
            if (grenade.pause>0) {
                grenade.pause = grenade.pause-1;
                if (grenade.pause==0) {
                    destroy(entity);
                }
                continue;

            }
            var health = entity.getComponent(Health);
            if (health.isDead()) {
                grenade.pause = 4;
                continue;
            }
            var state = entity.getComponent(State);
            if (state.getState()=="on") {
                var age = entity.getComponent(Age);
                var swapInterval = age.age>1000 ? 50 : 150;
                if ( (Std.int(age.age/swapInterval) % 2) == 0) {
                    entity.getComponent(Display).setFrameId("on");
                } else {
                    entity.getComponent(Display).setFrameId("off");                    
                }
                if (age.isExpired()) {
                    grenade.pause = 4;
                    continue;
                }
            }
        }
    }

    public function destroy(entity:Entity):Void {
        entity.addComponent(new ParticleEmitters([new glaze.particle.emitter.Explosion(30,100)]));
        entity.addComponent(new Destroy(1));
        glaze.util.CombatUtils.explode(entity.getComponent(Position).coords,64,100,entity);
    }

    public function on(state:State) {
        trace("active");
        state.owner.addComponent(new Age(2000,null));
    }

    public function off(state:State) {
        trace("inactive");
        state.owner.removeComponent(state.owner.getComponent(Age));
    }

    function activeState(entity:Entity,fsm:LWFSME,delta:Float) {
        var grenade = entity.getComponent(Grenade);
        grenade.fuse-=delta;
    }


}