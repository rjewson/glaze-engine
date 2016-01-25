package;

import exile.components.Door;
import exile.components.Player;
import exile.components.Teleporter;
import exile.systems.BeeHiveSystem;
import exile.systems.BeeSystem;
import exile.systems.ChickenSystem;
import exile.systems.DoorSystem;
import exile.systems.GrenadeSystem;
import exile.systems.MaggotSystem;
import exile.systems.PlayerSystem;
import exile.systems.TeleporterSystem;
import glaze.ai.steering.systems.SteeringSystem;
import glaze.animation.components.SpriteAnimation;
import glaze.animation.systems.AnimationSystem;
import glaze.eco.core.Entity;
import glaze.engine.actions.FilterSupport;
import glaze.engine.components.Active;
import glaze.engine.components.CollidableSwitch;
import glaze.engine.components.Destroy;
import glaze.engine.components.Display;
import glaze.engine.components.EnvironmentForce;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Holdable;
import glaze.engine.components.Moveable;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.engine.components.Script;
import glaze.engine.components.State;
import glaze.engine.components.Wind;
import glaze.engine.core.GameEngine;
import glaze.engine.factories.TMXFactory;
import glaze.engine.factories.tmx.LightFactory;
import glaze.engine.factories.tmx.WaterFactory;
import glaze.engine.systems.BehaviourSystem;
import glaze.engine.systems.CollidableSwitchSystem;
import glaze.engine.systems.DestroySystem;
import glaze.engine.systems.InventorySystem;
import glaze.engine.systems.ParticleSystem;
import glaze.engine.systems.RenderSystem;
import glaze.engine.systems.StateSystem;
import glaze.engine.systems.ViewManagementSystem;
import glaze.geom.Vector2;
import glaze.particle.BlockSpriteParticleEngine;
import glaze.particle.emitter.Explosion;
import glaze.physics.Body;
import glaze.physics.collision.broadphase.uniformgrid.UniformGrid;
import glaze.physics.collision.Intersect;
import glaze.physics.Material;
import glaze.physics.collision.Filter;
import glaze.physics.collision.Map;
import glaze.physics.collision.broadphase.BruteforceBroadphase;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.systems.ContactRouterSystem;
import glaze.physics.systems.PhysicsCollisionSystem;
import glaze.physics.systems.PhysicsConstraintSystem;
import glaze.physics.systems.PhysicsMoveableSystem;
import glaze.physics.systems.PhysicsPositionSystem;
import glaze.physics.systems.PhysicsStaticSystem;
import glaze.physics.systems.PhysicsUpdateSystem;
import glaze.render.renderers.webgl.SpriteRenderer;
import glaze.render.renderers.webgl.TileMap;
import glaze.tmx.TmxMap;
import glaze.util.MessageBus;
import glaze.util.Random.RandomInteger;
import js.Browser;
import js.html.CanvasElement;

class GameTestA extends GameEngine {
     
    public static inline var MAP_DATA:String = "data/testMap.tmx";
    public static inline var TEXTURE_CONFIG:String = "data/sprites.json";
    public static inline var FRAMES_CONFIG:String = "data/frames.json";
    public static inline var TEXTURE_DATA:String = "data/sprites.png";

    public static inline var TILE_SPRITE_SHEET:String = "data/spelunky-tiles.png";
    public static inline var TILE_MAP_DATA_1:String = "data/spelunky0.png";
    public static inline var TILE_MAP_DATA_2:String = "data/spelunky1.png";
  
    var tmxMap:TmxMap;
    var player:Entity;
    var playerFilter:Filter;
    var holderFilter:Filter; 
    var renderSystem:RenderSystem;     
    var filterSupport:FilterSupport;
    var messageBus:MessageBus;
    var blockParticleEngine:BlockSpriteParticleEngine;

    public var nf:Intersect;
    public var broadphase:glaze.physics.collision.broadphase.IBroadphase;

    public var killChickens:Bool = false;
 
    public var door:Entity;    
   
    public function new() {
        super(cast(Browser.document.getElementById("view"),CanvasElement));
        loadAssets([MAP_DATA,TEXTURE_CONFIG,TEXTURE_DATA,TILE_SPRITE_SHEET,TILE_MAP_DATA_1,TILE_MAP_DATA_2,FRAMES_CONFIG]);
    }

    override public function initalize() {
            
        var bs = new glaze.ds.BitSet(32);                
 
        var mustHave =  new glaze.ds.BitSet(32);
        mustHave.set(16); 

        for (i in 0...32) {
            bs.set(i);
            trace(bs.toString());
            trace(bs.containsAll(mustHave));     
        }

        setupMap();    
                    
        var corephase = engine.createPhase(); 
        var aiphase = engine.createPhase();//1000/30);  
        var physicsPhase = engine.createPhase();//1000/60);    
         
        messageBus = new MessageBus();
         
        renderSystem = new RenderSystem(canvas);
        renderSystem.textureManager.AddTexture(TEXTURE_DATA, assets.assets.get(TEXTURE_DATA) );
        renderSystem.textureManager.ParseTexturePackerJSON( assets.assets.get(TEXTURE_CONFIG) , TEXTURE_DATA );
         renderSystem.frameListManager.ParseFrameListJSON(assets.assets.get(FRAMES_CONFIG));

        var mapData = glaze.tmx.TmxLayer.LayerToCoordTexture(tmxMap.getLayer("Tile Layer 1"));
        var collisionData = glaze.tmx.TmxLayer.LayerToCollisionData(tmxMap.getLayer("Tile Layer 1"));

        var spriteRender = new SpriteRenderer(); 
        spriteRender.AddStage(renderSystem.stage);
        renderSystem.renderer.AddRenderer(spriteRender);
 
        blockParticleEngine = new BlockSpriteParticleEngine(4000,1000/60);
        renderSystem.renderer.AddRenderer(blockParticleEngine.renderer);

        var tileMap = new TileMap(); 
        renderSystem.renderer.AddRenderer(tileMap);    
        tileMap.SetSpriteSheet(assets.assets.get(TILE_SPRITE_SHEET));
        tileMap.SetTileLayerFromData(mapData,"base",1,1);
        // tileMap.SetTileLayer(assets.assets.get(TILE_MAP_DATA_2),"bg",0.6,0.6);
        tileMap.tileSize = 16 ;  
        tileMap.TileScale(2);          
                              
        // var map = new Map(tmxMap.getLayer("Tile Layer 1").tileGIDs); 
        var map = new Map(collisionData);   
        physicsPhase.addSystem(new PhysicsUpdateSystem());
        physicsPhase.addSystem(new SteeringSystem());

        nf = new glaze.physics.collision.Intersect();
        // broadphase = new UniformGrid(map,nf,10,5,640);
        broadphase = new BruteforceBroadphase(map,nf);
        // broadphase = new glaze.physics.collision.broadphase.SAPBroadphase(map,nf);

        exile.util.CombatUtils.setBroadphase(broadphase);

        physicsPhase.addSystem(new PhysicsStaticSystem(broadphase));
        physicsPhase.addSystem(new PhysicsMoveableSystem(broadphase));
        physicsPhase.addSystem(new PhysicsCollisionSystem(broadphase));
        physicsPhase.addSystem(new PhysicsConstraintSystem());     
        physicsPhase.addSystem(new PhysicsPositionSystem());
        physicsPhase.addSystem(new ContactRouterSystem());

        physicsPhase.addSystem(new glaze.engine.systems.WaterSystem(blockParticleEngine));

        physicsPhase.addSystem(new glaze.engine.systems.environment.EnvironmentForceSystem());
        physicsPhase.addSystem(new glaze.engine.systems.environment.WindRenderSystem(blockParticleEngine));

        physicsPhase.addSystem(new glaze.engine.systems.HolderSystem());
        physicsPhase.addSystem(new glaze.engine.systems.HeldSystem());
        physicsPhase.addSystem(new glaze.engine.systems.HoldableSystem());
        physicsPhase.addSystem(new glaze.engine.systems.HealthSystem());
        physicsPhase.addSystem(new glaze.engine.systems.AgeSystem());
                
        physicsPhase.addSystem(new exile.systems.ProjectileSystem());
                  
        /*      
         * Lighting RnD
         */
        //var lightSystem = new glaze.lighting.systems.LightingSystem(map);
        // renderSystem.renderer.AddRenderer(lightSystem.renderer);

        //This one
        // var lightSystem = new glaze.lighting.systems.PointLightingSystem(map);
        // renderSystem.renderer.AddRenderer(lightSystem.renderer);

        aiphase.addSystem(new BehaviourSystem());  
        aiphase.addSystem(new StateSystem(messageBus));  
        aiphase.addSystem(new CollidableSwitchSystem(messageBus));  
        aiphase.addSystem(new DoorSystem());                                                 
        aiphase.addSystem(new TeleporterSystem());                                                 
        aiphase.addSystem(new BeeHiveSystem());                                                 
        aiphase.addSystem(new BeeSystem(broadphase));  
        var chickenSystem:ChickenSystem = new ChickenSystem(blockParticleEngine);
        aiphase.addSystem(chickenSystem); 
        aiphase.addSystem(new MaggotSystem(broadphase,blockParticleEngine));                                              
        aiphase.addSystem(new GrenadeSystem(broadphase)); 
        aiphase.addSystem(new InventorySystem());                                                

        corephase.addSystem(new DestroySystem());
        corephase.addSystem(new PlayerSystem(input,blockParticleEngine));
        corephase.addSystem(new ViewManagementSystem(renderSystem.camera));

        corephase.addSystem(new ParticleSystem(blockParticleEngine));
        corephase.addSystem(new AnimationSystem(renderSystem.frameListManager));
        // and this one
        // corephase.addSystem(lightSystem);
        corephase.addSystem(renderSystem);   
         
        filterSupport = new FilterSupport(engine);  
  
        playerFilter = new Filter();
        playerFilter.maskBits = 0;
        playerFilter.groupIndex = 1; 

        var body = new glaze.physics.Body(new Material(1,0.3,0.1));
        body.maxScalarVelocity = 0;
        body.maxVelocity.setTo(160,1000);
    
        player = engine.createEntity([
            new Player(),
            new Position(300,180), 
            new Extents((10*3)/2,(14*3)/2),
            new Display("player"),
            new SpriteAnimation("player",["idle","scratch","shrug","run"],"idle"),
            new PhysicsBody(body),
            new PhysicsCollision(false,playerFilter,[]),
            new Moveable(),
            new Active()
        ],"player"); 

        chickenSystem.scaredOfPosition = player.getComponent(Position);

        // var serializer = new haxe.Serializer();
        // serializer.serialize(new Position(0,0));
        // var s = serializer.toString();
        // trace(s);  

        // var unserializer = new haxe.Unserializer(s);     
        // trace(unserializer.unserialize());
          
        // player.getComponent(Display).displayObject.scale.setTo(3,3);

        renderSystem.CameraTarget(player.getComponent(Position).coords);              

        var tmxFactory = new TMXFactory(engine,tmxMap);
        tmxFactory.registerFactory(LightFactory);
        tmxFactory.registerFactory(WaterFactory);
        tmxFactory.parseObjectGroup("Objects");

        createTurret();    
        createWind();
        createDoor();

        exile.entities.creatures.ChickenFactory.create(engine,mapPosition(9,2));
        exile.entities.creatures.MaggotFactory.create(engine,mapPosition(8,2));
        exile.entities.creatures.FishFactory.create(engine,mapPosition(37,21));

        loop.start();
    } 

    function setupMap() {
        tmxMap = new glaze.tmx.TmxMap(assets.assets.get(MAP_DATA));
        tmxMap.tilesets[0].set_image(assets.assets.get(TILE_SPRITE_SHEET));
    } 
  
    function mapPosition(xTiles:Float,yTiles:Float):Position {
        return new Position(xTiles*32,yTiles*32);
    }

    public function createWind() { 


        engine.createEntity([
            // new Position(32+16,512+16),  
            mapPosition(1.5,14.5),
            new Extents(16,256), 
            new PhysicsCollision(true,null,[]),
            new Fixed(),
            new EnvironmentForce(new Vector2(0,-40)),
            new Wind(1/100),
            new Active()
        ],"wind");         

        engine.createEntity([
                new Position((32*39)+16,(32*27)+16),  
                new Extents(6*32,1.5*32), 
                new PhysicsCollision(true,null,[]),
                new Fixed(),
                new EnvironmentForce(new Vector2(-10,0)),
                new Wind(1/100),
                new Active()
            ],"wind2");         
    }


    public function createDoor() {

        door = engine.createEntity([
            new Position(32*4.5,(32*6)+4),  
            new Extents(1,32),
            new Display("door"),
            new PhysicsCollision(false,null,[]),
            new Fixed(),
            new Door(false,""),
            new State(['closed','open'],0,["doorA"]),
            new Active()
        ],"door");        

        var doorSwitch = engine.createEntity([
            new Position((5*32)+10,(1*32)+10),  
            new Display("switch"), 
            new Extents(8,8),
            new PhysicsCollision(false,null,[]),
            new Fixed(),
            new CollidableSwitch(1000,["doorA"]),
            new Active()
        ],"turret");        
   
        engine.createEntity([
            new Position((32*24)+16,(32*6)),  
            new Extents(16,32),
            new PhysicsCollision(true,null,[]),
            new Fixed(),
            new Teleporter(new Vector2(32*24.5,32*2.5)),
            new ParticleEmitters([new glaze.particle.emitter.ScanLineEmitter(200,100,600,10)]),
            new State(["on","off"],0,[]),
            new Active()
            ],"teleporter");

        // engine.createEntity([
        //     new Position(20*32,4*32),  
        //     new Extents(16,16),
        //     new Display("enemies","turret"), 
        //     new PhysicsCollision(false,null,[]),
        //     new Fixed(),
        //     new Active(),
        //     new BeeHive(3)
        // ],"BeeHive"); 


        // var body = new glaze.physics.Body(new Material());

        engine.createEntity([
            new Position(10*32,4*32),  
            new Extents(4,4),
            new Display("items","rock"), 
            new PhysicsCollision(false,new Filter(),[]),
            new Moveable(),
            new PhysicsBody(new Body()),
            new Holdable(),
            new Active()
        ],"rock"); 


        engine.createEntity([
            new Position(9*32,6*32),  
            new Extents(8,5),
            new Display("blob"), 
            new PhysicsCollision(false,new Filter(),[]),
            new Moveable(),
            new PhysicsBody(Body.Create(null,0.1,0,1,100)),
            new Holdable(),
            new Active(),
            new SpriteAnimation("blob",["blob"],"blob"),
            new glaze.ai.steering.components.Steering([
                new glaze.ai.steering.behaviors.Wander(4,1,4)
            ])
        ],"blob"); 

    }

    public function createTurret() { 
        var behavior = new glaze.ai.behaviortree.Sequence();   
        behavior.addChild(new glaze.engine.actions.Delay(400,100));
        behavior.addChild(new glaze.engine.actions.InitEntityCollection());
        behavior.addChild(new glaze.engine.actions.QueryEntitiesInArea(200));
        behavior.addChild(new glaze.engine.actions.SortEntities(glaze.ds.EntityCollectionItem.SortClosestFirst));
        behavior.addChild(new glaze.engine.actions.FilterEntities([filterSupport.FilterStaticItems,filterSupport.FilterVisibleAgainstMap]));
        behavior.addChild(new glaze.ai.behaviortree.Action("fireBulletAtEntity",this));
         var turret = engine.createEntity([
            new Position(27*32,10*32),  
            new Display("enemies","turret"), 
            new Extents(12,12),
            new PhysicsCollision(false,playerFilter,[]),
            new Fixed(),
            new Script(behavior),
            new Active()
        ],"turret");        

    }
          
    public function fireBullet(pos:Vector2,target:Vector2,velocity:Float,ttl:Float,gff:Float=1):Void {
        var bullet = exile.entities.projectile.StandardBulletFactory.create(engine,new Position(pos.x,pos.y),playerFilter);
        glaze.util.Ballistics.calcProjectileVelocity(bullet.getComponent(PhysicsBody).body,target,velocity);        
    }    
    
    function fireBulletAtEntity(context:glaze.ai.behaviortree.BehaviorContext) {
        var ec:glaze.ds.EntityCollection = untyped context.data.ec;
        if (ec.length==0) return;
        fireBullet(
            context.entity.getComponent(Position).coords.clone(),
            ec.entities.head.entity.getComponent(Position).coords.clone(),
            1000,
            1000,
            0.1);  
    }

    public function dropGrenades() {
        var spread = 50;
        exile.entities.weapon.HandGrenadeFactory.create(engine,350,150);
        // exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*1,150);
        // exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*2,150);
        // exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*3,150);
        // exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*4,150);
        // exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*5,150);        
    }

    public function flyChickens() {
        for (i in 0 ... 10) {
            var pos = player.getComponent(Position).clone();
            var chickie = exile.entities.creatures.ChickenFactory.create(engine,pos);
            // var chickie = exile.entities.creatures.MaggotFactory.create(engine,pos);

            chickie.getComponent(PhysicsBody).body.addForce(new Vector2(RandomInteger(-1000,1000),RandomInteger(-1000,100)));

        }
    }

    public function destroyChickens() {
        var cs:ChickenSystem = cast engine.getSystem(ChickenSystem);
        var explosion:Explosion = new Explosion(10,50);
        var entity = cs.view.entities[0];
        if (entity!=null) {
            entity.addComponent(new Destroy(1)); 
            explosion.update(1,entity,blockParticleEngine);
        } else {
            killChickens = false;
        }
    }

    override public function preUpdate() {
        // trace(nf.collideCount);
        // nf.collideCount=0;
        input.Update(-renderSystem.camera.position.x,-renderSystem.camera.position.y);
        if (killChickens) {
            destroyChickens();
        }
    }

    public static function main() {
        var game = new GameTestA();
        glaze.debug.DebugEngine.gameEngine = game;

        Browser.document.getElementById("stopbutton").addEventListener("click",function(event){
            game.loop.stop();
        });
        Browser.document.getElementById("startbutton").addEventListener("click",function(event){
            game.loop.start();
        });       
        Browser.document.getElementById("debug1button").addEventListener("click",function(event){
            game.flyChickens();
        });        
        Browser.document.getElementById("debug2button").addEventListener("click",function(event){
            game.dropGrenades();
        });        
        Browser.document.getElementById("debug3button").addEventListener("click",function(event){
            // game.killChickens = true;
            untyped game.broadphase.dump();
        });        
        Browser.document.getElementById("entities").addEventListener("click",function(event){
            untyped Browser.window.writeResult(glaze.debug.DebugEngine.GetAllEntities());
        });
        Browser.document.getElementById("systems").addEventListener("click",function(event){
            untyped Browser.window.writeResult(glaze.debug.DebugEngine.GetAllSystems());
        });

    }   

}