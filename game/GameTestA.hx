package;

import exile.components.BeeHive;
import exile.components.Door;
import exile.components.Player;
import exile.components.Teleporter;
import exile.systems.BeeHiveSystem;
import exile.systems.BeeSystem;
import exile.systems.DoorSystem;
import exile.systems.GrenadeSystem;
import exile.systems.PlayerSystem;
import exile.systems.TeleporterSystem;
import glaze.ai.steering.systems.SteeringSystem;
import glaze.eco.core.Entity;
import glaze.engine.actions.FilterSupport;
import glaze.engine.components.CollidableSwitch;
import glaze.engine.components.Display;
import glaze.engine.components.EnvironmentForce;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Holdable;
import glaze.engine.components.Inventory;
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
import glaze.physics.Body;
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
import glaze.render.renderers.webgl.FBOLighting;
import glaze.render.renderers.webgl.SpriteRenderer;
import glaze.render.renderers.webgl.TileMap;
import glaze.tmx.TmxMap;
import glaze.util.MessageBus;
import js.Browser;
import js.html.CanvasElement;

class GameTestA extends GameEngine {
     
    public static inline var MAP_DATA:String = "data/testMap.tmx";
    public static inline var TEXTURE_CONFIG:String = "data/sprites.json";
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

    public var door:Entity; 
  
    public function new() {
        super(cast(Browser.document.getElementById("view"),CanvasElement));
        loadAssets([MAP_DATA,TEXTURE_CONFIG,TEXTURE_DATA,TILE_SPRITE_SHEET,TILE_MAP_DATA_1,TILE_MAP_DATA_2]);
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
        
        var mapData = glaze.tmx.TmxLayer.LayerToCoordTexture(tmxMap.getLayer("Tile Layer 1"));
        var collisionData = glaze.tmx.TmxLayer.LayerToCollisionData(tmxMap.getLayer("Tile Layer 1"));
              
  
        var spriteRender = new SpriteRenderer();
        spriteRender.AddStage(renderSystem.stage);
        renderSystem.renderer.AddRenderer(spriteRender);
 
        var blockParticleEngine = new BlockSpriteParticleEngine(4000,1000/60);
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
        var broadphase = new BruteforceBroadphase(map,new glaze.physics.collision.Intersect());
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
                
        physicsPhase.addSystem(new exile.systems.ProjectileSystem(broadphase));
                  
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
        aiphase.addSystem(new GrenadeSystem(broadphase)); 
        aiphase.addSystem(new InventorySystem());                                                

        corephase.addSystem(new DestroySystem());
        corephase.addSystem(new PlayerSystem(input,blockParticleEngine));
        corephase.addSystem(new ViewManagementSystem(renderSystem.camera));

        corephase.addSystem(new ParticleSystem(blockParticleEngine));
        // and this one
        // corephase.addSystem(lightSystem);
        corephase.addSystem(renderSystem);   
         
        filterSupport = new FilterSupport(engine);
  
        playerFilter = new Filter();
        playerFilter.maskBits = 0;
        playerFilter.groupIndex = 1; 

        var body = new glaze.physics.Body(new Material());
        body.maxScalarVelocity = 0;
        body.maxVelocity.setTo(160,1000);
    
        player = engine.createEntity([
            new Player(),
            new Position(300,180),
            new Extents(30/2,72/2),
            new Display("character1.png"),
            new PhysicsBody(body),
            new PhysicsCollision(false,playerFilter,[]),
            new Moveable()
        ],"player"); 

        // var serializer = new haxe.Serializer();
        // serializer.serialize(new Position(0,0));
        // var s = serializer.toString();
        // trace(s);

        // var unserializer = new haxe.Unserializer(s);
        // trace(unserializer.unserialize());


        renderSystem.CameraTarget(player.getComponent(Position).coords);              

        var tmxFactory = new TMXFactory(engine,tmxMap);
        tmxFactory.registerFactory(LightFactory);
        tmxFactory.registerFactory(WaterFactory);
        tmxFactory.parseObjectGroup("Objects");

        createTurret();    
        createWind();
        createDoor();

        loop.start();
    } 

    function setupMap() {
        tmxMap = new glaze.tmx.TmxMap(assets.assets.get(MAP_DATA));
        tmxMap.tilesets[0].set_image(assets.assets.get(TILE_SPRITE_SHEET));
    } 
  
    public function createWind() { 
        engine.createEntity([
            new Position(32+16,512+16),  
            new Extents(16,256),
            new PhysicsCollision(true,null,[]),
            new Fixed(),
            new EnvironmentForce(new Vector2(0,-40)),
            new Wind(1/100)
        ],"wind");        
    }

    public function createDoor() {
        door = engine.createEntity([
            new Position(128,32*5.5),  
            new Extents(16,32+16),
            new Display("door.png"),
            new PhysicsCollision(false,null,[]),
            new Fixed(),
            new Door(false,""),
            new State(['closed','open'],0,["doorA"])
        ],"door");        

        var doorSwitch = engine.createEntity([
            new Position(336,100),  
            // new Position(432,148),   
            // new Position(200,465),  
            new Display("turretA.png"), 
            new Extents(12,12),
            new PhysicsCollision(false,null,[]),
            new Fixed(),
            new CollidableSwitch(1000,["doorA"])
        ],"turret");        

        engine.createEntity([
            new Position(300,32+16),  
            new Extents(16,16),
            new PhysicsCollision(true,null,[]),
            new Fixed(),
            new Teleporter(new Vector2(100,100)),
            new ParticleEmitters([new glaze.particle.emitter.ScanLineEmitter(200,100,600,10)]),
            new State(["on","off"],0,[])
            ],"teleporter");

        engine.createEntity([
            new Position(20*32,4*32),  
            new Extents(16,16),
            new Display("turretA.png"), 
            new PhysicsCollision(false,null,[]),
            new Fixed(),
            new BeeHive(3)
        ],"BeeHive"); 

    }

    public function createTurret() { 
return;
        var behavior = new glaze.ai.behaviortree.Sequence();   
        behavior.addChild(new glaze.engine.actions.Delay(1000,100));
        behavior.addChild(new glaze.engine.actions.InitEntityCollection());
        behavior.addChild(new glaze.engine.actions.QueryEntitiesInArea(200));
        behavior.addChild(new glaze.engine.actions.SortEntities(glaze.ds.EntityCollectionItem.SortClosestFirst));
        behavior.addChild(new glaze.engine.actions.FilterEntities([filterSupport.FilterVisibleAgainstMap]));
        behavior.addChild(new glaze.ai.behaviortree.Action("fireBulletAtEntity",this));
// return;
         var turret = engine.createEntity([
            new Position(336,100),  
            // new Position(432,148),   
            // new Position(200,465),  
            new Display("turretA.png"), 
            new Extents(12,12),
            new PhysicsCollision(false,playerFilter,[]),
            new Fixed(),
            new Script(behavior)
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
        exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*1,150);
        exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*2,150);
        exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*3,150);
        exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*4,150);
        exile.entities.weapon.HandGrenadeFactory.create(engine,350+spread*5,150);        
    }

    override public function preUpdate() {
        input.Update(-renderSystem.camera.position.x,-renderSystem.camera.position.y);
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
        Browser.document.getElementById("debugbutton").addEventListener("click",function(event){
            game.dropGrenades();
        });        
        Browser.document.getElementById("entities").addEventListener("click",function(event){
            untyped Browser.window.writeResult(glaze.debug.DebugEngine.GetAllEntities());
        });
        Browser.document.getElementById("systems").addEventListener("click",function(event){
            untyped Browser.window.writeResult(glaze.debug.DebugEngine.GetAllSystems());
        });

    }   

}