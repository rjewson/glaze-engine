package exile.systems;

import exile.components.Bird;
import exile.components.Grenade;
import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorTree;
import glaze.ai.behaviortree.branch.Sequence;
import glaze.ai.behaviortree.decorator.RepeatUntilFail;
import glaze.ai.behaviortree.decorator.RepeatUntilSuccess;
import glaze.ai.steering.behaviors.Arrival;
import glaze.ai.steering.behaviors.Wander;
import glaze.ai.steering.components.Steering;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.actions.CanSee;
import glaze.engine.actions.Delay;
import glaze.engine.actions.FindTarget;
import glaze.engine.actions.SeekTarget;
import glaze.engine.components.Age;
import glaze.engine.components.Destroy;
import glaze.engine.components.Health;
import glaze.engine.components.Position;
import glaze.engine.states.LogState;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Contact;
import glaze.physics.components.PhysicsCollision;
import glaze.ai.stackfsm.LWStackFSM;

class BirdSystem extends System {

    var broadphase:IBroadphase;
    var bfAreaQuery:glaze.util.BroadphaseAreaQuery;

    public function new(broadphase:IBroadphase) {
        super([Bird,PhysicsCollision,Health,Age,Steering]);
        this.broadphase = broadphase;
        bfAreaQuery = new glaze.util.BroadphaseAreaQuery(broadphase);
    }

    override public function entityAdded(entity:Entity) {   
        var bird = entity.getComponent(Bird);
        bird.ai.pushState(baseState);

        bird.ai2 = BehaviorTree.createScript("bird");
        bird.ctx = new BehaviorContext(entity);
        bird.ctx.data.set("home",bird.nest.getComponent(Position).coords.clone());
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var bird = entity.getComponent(Bird);
            // bird.ai.update(entity,delta);

            bird.ctx.delta = delta;
            // js.Lib.debug();
            bird.ai2.tick(bird.ctx);

            // var health = entity.getComponent(Health);
            // var age = entity.getComponent(Age);
            // if (health.isDead()||age.isExpired()) {
            //     entity.addComponent(new glaze.engine.components.ParticleEmitters([new glaze.particle.emitter.Explosion(1,200)]));
            //     entity.addComponent(new Destroy(2)); 
            // }
        }
    }

    function baseState(entity:Entity,fsm:LWFSME,delta:Float) {
        var bird = entity.getComponent(Bird);
        if (bird.delay.tick(delta)) {
            fsm.pushState(seekState);
        }
    }

    function seekState(entity:Entity,fsm:LWFSME,delta:Float) {

        //Find enemies within 300 units
        var entities = glaze.util.CombatUtils.searchSortAndFilter(entity.getComponent(Position).coords,300,entity,glaze.util.CombatUtils.EntityFilterOptions.ALL).entities;
        //Found something
        if (entities.head!=null) {
        
            var bird = entity.getComponent(Bird);
            bird.target = entities.head.entity;

            var steering = entity.getComponent(Steering);
            var arrival:Arrival = cast steering.getBehaviour(Arrival);
            arrival.target = bird.target.getComponent(Position).coords;
            arrival.arrivalZone = 1;

            var wander:Wander = cast steering.getBehaviour(Wander);
            wander.active = false;

            fsm.popState();
            fsm.pushState(chaseState);
            return;       
        }
        fsm.popState();
    }

    function chaseState(entity:Entity,fsm:LWFSME,delta:Float) {

        var bird = entity.getComponent(Bird);
        //Need to check?
        if (bird.chaseCheck.tick(delta))
            return;
        //Yes, ok check if we can still see the target
        if (glaze.util.CombatUtils.canSee(entity.getComponent(Position).coords,bird.target.getComponent(Position).coords,300)) 
            return;

        var bird = entity.getComponent(Bird);
        bird.target = null;
        var steering = entity.getComponent(Steering);

        var wander:Wander = cast steering.getBehaviour(Wander);
        wander.active = true;
        var arrival:Arrival = cast steering.getBehaviour(Arrival);
        arrival.target = bird.nest.getComponent(Position).coords;
        arrival.arrivalZone = 128;

        fsm.popState();

    }

    // function CreateAI():Behavior {

    //     var birdScript = BehaviorTree.createScript("bird");
    //     return birdScript;

    //     //Set target data
    //     //Set home data
    //     var mainSeq = new Sequence();
    //     var rep = new glaze.ai.behaviortree.decorator.Repeat(0);
    //     rep.addChild(mainSeq);
    //     mainSeq.addChild(new glaze.ai.behaviortree.leaf.CopyContextData("home","target"));
    //     mainSeq.addChild(new glaze.engine.actions.WanderToTarget(128));

    //     var succSeq = new Sequence();
    //     succSeq.addChild(new Delay(1000));
    //     succSeq.addChild(new FindTarget());
    //     var repSucc = new RepeatUntilSuccess();
    //     repSucc.addChild(succSeq);
    //     mainSeq.addChild(repSucc);

    //     mainSeq.addChild(new SeekTarget());

    //     var failSeq = new Sequence();
    //     failSeq.addChild(new Delay(1000));
    //     failSeq.addChild(new CanSee());
    //     var repFail = new RepeatUntilFail();
    //     repFail.addChild(failSeq);
    //     mainSeq.addChild(repFail);
 
    //     return rep;

    // }

/*


    set (home)
    repeat
        sequence
            set target (home)
            wander (to target) (always sucess)
            repeat until sucess
                sequence
                    delay
                    can see enemy? set target
            chase (target)
            repeat until failure
                sequence
                    can see (target)
                    delay

        

*/


}