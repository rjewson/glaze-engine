package exile.systems;

import exile.components.Player;
import exile.util.CharacterController2;
import glaze.animation.components.SpriteAnimation;
import glaze.core.DigitalInput;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Active;
import glaze.engine.components.Extents;
import glaze.engine.components.Holder;
import glaze.engine.components.Inventory;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.engine.components.State;
import glaze.engine.components.Viewable;
import glaze.lighting.components.Light;
import glaze.particle.IParticleEngine;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;

/*
backspace   8
tab 9
enter   13
shift   16
ctrl    17
alt 18
pause/break 19
caps lock   20
escape  27
page up 33
page down   34
end 35
home    36
left arrow  37
up arrow    38
right arrow 39
down arrow  40
insert  45
delete  46

0   48
1   49
2   50
3   51
4   52
5   53
6   54
7   55
8   56
9   57

a   65
b   66
c   67
d   68
e   69
f   70
g   71
h   72
i   73
j   74
k   75
l   76
m   77
n   78
o   79
p   80
q   81
r   82
s   83
t   84
u   85
v   86
w   87
x   88
y   89
z   90
*/
class PlayerSystem extends System {

    public var particleEngine:IParticleEngine;
    public var input:DigitalInput;  

    var player:Entity;
    var position:Position;
    var physicsBody:PhysicsBody;

    var playerLight:Entity;
    var playerHolder:Entity;
    var holder:Holder;
    var inventory:Inventory;

    var animation:SpriteAnimation;

    var characterController:CharacterController2; 

    var playerFilter:Filter;

    var currentWeapon:Int = 0;

    public function new(input:DigitalInput,particleEngine:IParticleEngine,spriteParticleEngine:IParticleEngine) {
        super([Player,PhysicsCollision,PhysicsBody,SpriteAnimation,Extents]);
        this.input = input;
        this.particleEngine = particleEngine;
    }

    override public function entityAdded(entity:Entity) {

        player = entity;
        position = entity.getComponent(Position);
        physicsBody = entity.getComponent(PhysicsBody);

        // physicsBody.body.setMass(880);
        physicsBody.body.usesStairs = true;
        
        characterController = new CharacterController2(input,physicsBody.body);

        playerLight = engine.createEntity( 
            [  
            position, 
            new Light(256,1,1,0,255,255,255),
            new Viewable(),
            new Moveable(),
            new Active()
            ],"player light");  

        holder = new Holder();
        inventory = new Inventory(4);         

        playerHolder = engine.createEntity([
            position,
            entity.getComponent(Extents),
            holder,
            new PhysicsCollision(true,new Filter(1,0,exile.ExileFilters.PLAYER_GROUP),[]),
            new Moveable(),
            new Active(),
            inventory
        ],"playerHolder");
        player.addChildEntity(playerHolder);
        player.addChildEntity(playerLight);

        playerFilter = entity.getComponent(PhysicsCollision).proxy.filter;

        animation = entity.getComponent(SpriteAnimation);

    }

    override public function entityRemoved(entity:Entity) {
        js.Lib.debug();  
    }

    override public function update(timestamp:Float,delta:Float) {

        characterController.update();

        // if (characterController.isWalking) {
        if (physicsBody.body.onGround&&Math.abs(physicsBody.body.velocity.x)>10) {
            animation.animationController.play("runright");
        } else if (!physicsBody.body.onGround) {
            animation.animationController.play("fly");            
        } else {
            animation.animationController.play("idle");
        }

        if (characterController.left>0)
            position.direction.x = -1;
        if (characterController.right>0)
            position.direction.x = 1;

        physicsBody.body.collideOneWay = !(characterController.down>0);

        var fire = input.JustPressed(32);
        var search = input.JustPressed(71);
        var hold = input.Pressed(72); 
        var ray = input.Pressed(82);

        if (input.JustPressed(84)) {
            var lightActive = playerLight.getComponent(Viewable);
            if (lightActive!=null)
                playerLight.removeComponent(lightActive);
                // playerLight.removeComponent2(Light);
            else
                playerLight.addComponent(new Viewable());
        }
        //u    
        if (input.Pressed(85)) {
            exile.entities.creatures.BeeFactory.create(engine,position.clone());
        }
        
        holder.activate = input.JustPressed(72);
        // trace("x");

        if (input.JustPressed(74)) {
            //Drop Item 'J'
            var item = holder.drop();
        } else if (input.JustPressed(75)) {
            //Throw Item 'K'
            var item = holder.drop();
            if (item!=null) {
                glaze.util.Ballistics.calcProjectileVelocity(item.getComponent(PhysicsBody).body,input.ViewCorrectedMousePosition(),700);        
            }
        }

        if (input.JustPressed(81)) { //Q
            if (holder.heldItem!=null) {
                var state = holder.heldItem.getComponent(State);
                if (state!=null) {
                    state.incrementState();
                }
            }
        }

        if (input.JustPressed(90)) {
            // js.Lib.debug();
            
            inventory.store();
        }        

        if (input.JustPressed(88)) {
            inventory.retrieve();
        }

        if (fire) {
            if (currentWeapon==0)
                exile.entities.projectile.StandardBulletFactory.create(engine,position.clone(),playerFilter.clone(),input.ViewCorrectedMousePosition());
            if (currentWeapon==1)
                exile.entities.projectile.PlasmaProjectileFactory.create(engine,position.clone(),playerFilter.clone(),input.ViewCorrectedMousePosition());

        } 
        //'e' aim
        if (input.Pressed(69)) {
            var vel = input.ViewCorrectedMousePosition().clone();
            vel.minusEquals(position.coords);
            vel.normalize();
            vel.multEquals(2000); 
            particleEngine.EmitParticle(position.coords.x,position.coords.y,vel.x,vel.y,0,0,200,1,false,true,null,4,255,255,255,255);
        }

        if (characterController.burn>0) {
            var ttl = 280;
            var offsetx = position.coords.x-(8*position.direction.x);
            var velocity =  200 + glaze.util.Random.RandomInteger(-150,150);// + physicsBody.body.velocity.y;
            var count = Math.floor( (characterController.burn+500)/1000);
            if (count>0)
                particleEngine.EmitParticle(offsetx,position.coords.y+6,glaze.util.Random.RandomFloat(-10,10),velocity,0,0,40,0.9,false,false,null,4,255,255,0,0);
            for (i in 0 ... count) {
                particleEngine.EmitParticle(offsetx,position.coords.y+6,glaze.util.Random.RandomFloat(-50,50),velocity,0,0,ttl,0.9,true,true,null,4,255,255,255,255);                
            }
        }

        if (input.JustPressed(49))
            currentWeapon = 0;
        if (input.JustPressed(50))
            currentWeapon = 1;

    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {

    }


    function initPlayer() {
    }

}