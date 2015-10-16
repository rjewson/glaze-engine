package exile.systems;

import exile.components.Player;
import exile.util.CharacterController;
import glaze.core.DigitalInput;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Holder;
import glaze.engine.components.Moveable;
import glaze.engine.components.Position;
import glaze.engine.components.Viewable;
import glaze.lighting.components.Light;
import glaze.particle.IParticleEngine;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.collision.Filter;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;

class PlayerSystem extends System {

    public var particleEngine:IParticleEngine;
    public var input:DigitalInput;  

    var player:Entity;
    var position:Position;
    var physicsBody:PhysicsBody;

    var playerLight:Entity;
    var playerHolder:Entity;
    var holder:Holder;

    var characterController:CharacterController; 

    var playerFilter:Filter;

    public function new(input:DigitalInput,particleEngine:IParticleEngine) {
        super([Player,PhysicsCollision,PhysicsBody,Extents]);
        this.input = input;
        this.particleEngine = particleEngine;
    }

    override public function entityAdded(entity:Entity) {

        player = entity;
        position = entity.getComponent(Position);
        physicsBody = entity.getComponent(PhysicsBody);

        characterController = new CharacterController(input,physicsBody.body);

        playerLight = engine.createEntity( 
            [  
            position, 
            new Light(256,1,1,0,255,255,255),
            new Viewable(),
            new Moveable()
            ],"player light");  

        holder = new Holder();
        playerHolder = engine.createEntity([
            position,
            entity.getComponent(Extents),
            holder,
            new glaze.physics.components.PhysicsCollision(true,new Filter(),[]),
            new Moveable()
        ],"playerHolder");
        player.addChildEntity(playerHolder);

        playerFilter = entity.getComponent(PhysicsCollision).proxy.filter;

    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {

        characterController.update();

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
        if (input.JustPressed(85)) {
            new exile.entities.creatures.Bee().create(engine,position.clone());
        }
        
        holder.hold = input.JustPressed(72);
        if (input.JustPressed(74)) {
            var item = holder.drop();
            if (item!=null) {
                glaze.util.Ballistics.calcProjectileVelocity(item.getComponent(PhysicsBody).body,input.ViewCorrectedMousePosition(),500);        
            }
        }

        if (fire) {
            var bullet = exile.entities.projectile.StandardBullet.create(engine,position.clone(),playerFilter);
            glaze.util.Ballistics.calcProjectileVelocity(bullet.getComponent(PhysicsBody).body,input.ViewCorrectedMousePosition(),1500);        

        } 
        
    }

    public function callback(a:BFProxy,b:BFProxy,contact:Contact) {
    }


    function initPlayer() {
    }

}