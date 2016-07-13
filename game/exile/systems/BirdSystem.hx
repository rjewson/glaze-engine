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
import glaze.eco.core.Engine;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.actions.CanSee;
import glaze.engine.actions.Delay;
import glaze.engine.actions.FindTarget;
import glaze.engine.actions.SeekTarget;
import glaze.engine.components.Age;
import glaze.engine.components.Destroy;
import glaze.engine.components.Extents;
import glaze.engine.components.Health;
import glaze.engine.components.Position;
import glaze.physics.Body;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Contact;
import glaze.physics.collision.Map;
import glaze.physics.components.PhysicsCollision;
import glaze.ai.fsm.LightStackStateMachine;
import glaze.physics.Material;
import glaze.util.EntityUtils;

class BirdSystem extends System {

    var broadphase:IBroadphase;   
    var bfAreaQuery:glaze.util.BroadphaseAreaQuery;

    public function new(broadphase:IBroadphase) {
        super([Bird,PhysicsCollision,Health,Steering]);
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


    public static function create(engine:Engine,position:Position,follow:Position,nest:Entity):Entity {

        var birdBody = new Body(new Material());
        birdBody.setMass(1);
        birdBody.setBounces(0);     
        birdBody.globalForceFactor = 0.0;
        birdBody.maxScalarVelocity = 200; 

        var map:Map = cast engine.config.map;

        var bird = engine.createEntity([
            position, 
            new Bird(nest),
            new Extents((4)*1,(4)*1),
            new glaze.engine.components.Display("bird"), 
            new glaze.physics.components.PhysicsBody(birdBody,false), 
            new glaze.engine.components.Moveable(),
            new PhysicsCollision(false,null,[]),  
            new glaze.animation.components.SpriteAnimation("bird",["fly"],"fly"),
            // new Light(64,1,1,1,255,255,0),
            new Steering([
                new Wander(55,80,0.3) //ok
                ,new Arrival(follow.coords,256)
                //,new Seek(follow.coords,32)
                // new Arrival(follow.coords,128,32)
                ,new glaze.ai.steering.behaviors.WallAvoidance(map,60)
                ]),
            new Age(10000,EntityUtils.standardDestroy),
            new Health(10,10,0,EntityUtils.standardDestroy),
            new glaze.engine.components.Active()
        ],"bird"); 

        return bird;        
    }

    public static function destroy(entity:Entity) {
        trace("bang");  
    }


}