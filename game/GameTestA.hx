package;
 
import exile.components.Door;
import exile.components.Player;
import exile.components.Teleporter;
import exile.ExileFilters;
import exile.systems.BeeHiveSystem;
import exile.systems.BeeSystem;
import exile.systems.ChickenSystem;
import exile.systems.DoorSystem;
import exile.systems.GrenadeSystem;  
import exile.systems.MaggotSystem;  
import exile.systems.PlayerSystem;
import exile.systems.RabbitSystem;
import exile.systems.TeleporterSystem;        
import glaze.ai.navigation.AStar;
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
import glaze.particle.PointSpriteParticleEngine;
import glaze.particle.SpriteParticleManager;
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
     
    public static inline var MAP_DATA:String = "data/newMap.tmx";

    public static inline var TEXTURE_CONFIG:String = "data/sprites.json";
    public static inline var TEXTURE_DATA:String = "data/sprites.png";
    public static inline var FRAMES_CONFIG:String = "data/frames.json";

    public static inline var PARTICLE_TEXTURE_CONFIG:String = "data/particles.json";
    public static inline var PARTICLE_TEXTURE_DATA:String = "data/particles.png";
    public static inline var PARTICLE_FRAMES_CONFIG:String = "data/particleFrames.json";


    public static inline var COL_SPRITE_SHEET:String = "data/collisionTiles.png";
    public static inline var TILE_SPRITE_SHEET_1:String = "data/set1.png";
    public static inline var TILE_SPRITE_SHEET_2:String = "data/set2.png";
    public static inline var TILE_SPRITE_SHEET_B:String = "data/setB.png";

    // public static inline var TILE_SPRITE_SHEET:String = "data/spelunky-tiles.png";
    // public static inline var TILE_MAP_DATA_1:String = "data/spelunky0.png";
    // public static inline var TILE_MAP_DATA_2:String = "data/spelunky1.png";
  
    var tmxMap:TmxMap;
    var player:Entity;
    var playerFilter:Filter;
    var holderFilter:Filter; 
    var renderSystem:RenderSystem;     
    var filterSupport:FilterSupport;
    var messageBus:MessageBus;
    var blockParticleEngine:BlockSpriteParticleEngine;
    var spriteParticleEngine:PointSpriteParticleEngine;

    public var nf:Intersect;
    public var broadphase:glaze.physics.collision.broadphase.IBroadphase;

    public var killChickens:Bool = false;
    public var shakeIt:Float = 0;
 
    public var door:Entity;    
   
    public function new() {
        super(cast(Browser.document.getElementById("view"),CanvasElement));
        loadAssets([
            MAP_DATA,
            TEXTURE_CONFIG,
            TEXTURE_DATA,
            PARTICLE_TEXTURE_CONFIG,
            PARTICLE_TEXTURE_DATA,
            PARTICLE_FRAMES_CONFIG,
            TILE_SPRITE_SHEET_1,
            TILE_SPRITE_SHEET_2,
            TILE_SPRITE_SHEET_B,
            COL_SPRITE_SHEET,
            FRAMES_CONFIG
        ]);
    }
  
    override public function initalize() {
              
        // var bs = new glaze.ds.BitSet(32);                
 
        // var mustHave =  new glaze.ds.BitSet(32);
        // mustHave.set(16); 

        // for (i in 0...32) { 
        //     bs.set(i);
        //     trace(bs.toString());
        //     trace(bs.containsAll(mustHave));     
        // } 
   
        engine.config.tileSize = 16;

        tmxMap = new glaze.tmx.TmxMap(assets.assets.get(MAP_DATA));

        tmxMap.tilesets[0].set_image(assets.assets.get(COL_SPRITE_SHEET));
        tmxMap.tilesets[1].set_image(assets.assets.get(TILE_SPRITE_SHEET_1));
        tmxMap.tilesets[2].set_image(assets.assets.get(TILE_SPRITE_SHEET_2));
        tmxMap.tilesets[3].set_image(assets.assets.get(TILE_SPRITE_SHEET_B));
                       
        var aiphase = engine.createPhase();//1000/30);  
        var physicsPhase = engine.createPhase();//1000/60);    
        var corephase = engine.createPhase(); 
          
        messageBus = new MessageBus();  
         
        renderSystem = new RenderSystem(canvas);
        
        renderSystem.textureManager.AddTexture(TEXTURE_DATA, assets.assets.get(TEXTURE_DATA) );
        renderSystem.textureManager.AddTexture(PARTICLE_TEXTURE_DATA, assets.assets.get(PARTICLE_TEXTURE_DATA) );
        renderSystem.textureManager.AddTexture(TILE_SPRITE_SHEET_1, assets.assets.get(TILE_SPRITE_SHEET_1) );
        renderSystem.textureManager.AddTexture(TILE_SPRITE_SHEET_2, assets.assets.get(TILE_SPRITE_SHEET_2) );
        renderSystem.textureManager.AddTexture(TILE_SPRITE_SHEET_B, assets.assets.get(TILE_SPRITE_SHEET_B) );

        renderSystem.textureManager.ParseTexturePackerJSON( assets.assets.get(TEXTURE_CONFIG) , TEXTURE_DATA );
        renderSystem.frameListManager.ParseFrameListJSON(assets.assets.get(FRAMES_CONFIG));
    
// js.Lib.debug(); 
        var background = glaze.tmx.TmxLayer.LayerToCoordTexture(tmxMap.getLayer("Background"));
        var foreground1 = glaze.tmx.TmxLayer.LayerToCoordTexture(tmxMap.getLayer("Foreground1"));
        var foreground2 = glaze.tmx.TmxLayer.LayerToCoordTexture(tmxMap.getLayer("Foreground2"));
      
        var collisionData = glaze.tmx.TmxLayer.LayerToCollisionData(tmxMap.getLayer("Collision"));
        
        var tileMap = new TileMap();     
        renderSystem.renderer.AddRenderer(tileMap);    
        // tileMap.SetSpriteSheet(assets.assets.get(TILE_SPRITE_SHEET));  
  
        tileMap.SetTileLayerFromData(foreground2,renderSystem.textureManager.baseTextures.get(TILE_SPRITE_SHEET_2),"f2",1,1); 
        tileMap.SetTileLayerFromData(foreground1,renderSystem.textureManager.baseTextures.get(TILE_SPRITE_SHEET_1),"f1",1,1);
        tileMap.SetTileLayerFromData(background,renderSystem.textureManager.baseTextures.get(TILE_SPRITE_SHEET_B),"bg",1,1);
        // tileMap.SetTileLayerFromData(mapData,"base",0.5,0.5);
        // tileMap.SetTileLayerFromData(mapData,"base",1,1);
        // tileMap.SetTileLayer(assets.assets.get(TILE_MAP_DATA_2),"bg",0.6,0.6);
        tileMap.tileSize = 16 ;                 
        tileMap.TileScale(2);             
      
        var spriteRender = new SpriteRenderer(); 
        spriteRender.AddStage(renderSystem.stage);
        renderSystem.renderer.AddRenderer(spriteRender);
 
        blockParticleEngine = new BlockSpriteParticleEngine(4000,1000/60,collisionData);
        renderSystem.renderer.AddRenderer(blockParticleEngine.renderer);
     

        var spriteParticleManager:SpriteParticleManager = new SpriteParticleManager();
        spriteParticleManager.ParseTexturePackerJSON(assets.assets.get(PARTICLE_TEXTURE_CONFIG));
        spriteParticleManager.ParseSequenceJSON(assets.assets.get(PARTICLE_FRAMES_CONFIG));
        spriteParticleEngine = new PointSpriteParticleEngine(4000,1000/60,spriteParticleManager,collisionData);
        renderSystem.renderer.AddRenderer(spriteParticleEngine.renderer);
        spriteParticleEngine.renderer.SetSpriteSheet(renderSystem.textureManager.baseTextures.get(PARTICLE_TEXTURE_DATA).texture,16,16,16);

        var map = new Map(collisionData);  
        exile.entities.creatures.BeeFactory.map = map; 
        physicsPhase.addSystem(new PhysicsUpdateSystem());
        physicsPhase.addSystem(new SteeringSystem());
 
        nf = new glaze.physics.collision.Intersect(); 

        // broadphase = new UniformGrid(map,nf,10,5,640);
        // broadphase = new glaze.physics.collision.broadphase.SAPBroadphase(map,nf);
  
        broadphase = new BruteforceBroadphase(map,nf);

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

        physicsPhase.addSystem(new glaze.engine.systems.HolderSystem(exile.ExileFilters.HOLDABLE_CAT));
        physicsPhase.addSystem(new glaze.engine.systems.HeldSystem());
        physicsPhase.addSystem(new glaze.engine.systems.HoldableSystem(exile.ExileFilters.HOLDABLE_CAT));
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
        var rabbitSystem = new RabbitSystem();
        aiphase.addSystem(rabbitSystem); 
        aiphase.addSystem(new MaggotSystem(broadphase,blockParticleEngine));                                              
        aiphase.addSystem(new GrenadeSystem(broadphase)); 
        aiphase.addSystem(new InventorySystem());                                                

        corephase.addSystem(new DestroySystem());
        corephase.addSystem(new PlayerSystem(input,blockParticleEngine,spriteParticleEngine));
        corephase.addSystem(new ViewManagementSystem(renderSystem.camera));

        corephase.addSystem(new ParticleSystem(blockParticleEngine,spriteParticleEngine));
        corephase.addSystem(new AnimationSystem(renderSystem.frameListManager));

        // and this one
        // corephase.addSystem(lightSystem);
        corephase.addSystem(renderSystem);    
         
        filterSupport = new FilterSupport(engine);  
   
        playerFilter = new Filter();
        playerFilter.categoryBits = ExileFilters.PLAYER_CAT;
        playerFilter.maskBits |= ExileFilters.PROJECTILE_CAT;
        playerFilter.groupIndex = ExileFilters.PLAYER_GROUP; 

        var body = new glaze.physics.Body(new Material(1,0.3,0.1));
        body.maxScalarVelocity = 0;
        body.maxVelocity.setTo(1600,1000);

        player = engine.createEntity([
            new Player(),
            new Position(300,180), 
            new Extents(12,24),
            new Display("player"),        
            new SpriteAnimation("player",["idle","scratch","shrug","fly","runright"],"idle"),
            new PhysicsBody(body),
            new PhysicsCollision(false,playerFilter,[]),
            new Moveable(),
            new Active()
        ],"player"); 
        
        chickenSystem.scaredOfPosition = player.getComponent(Position);
        rabbitSystem.scaredOfPosition = player.getComponent(Position);

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
        exile.entities.creatures.RabbitFactory.create(engine,mapPosition(9,2));
        exile.entities.creatures.FishFactory.create(engine,mapPosition(37,21));

        loop.start();
    } 

    function setupMap() {
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
            new Extents(3,34),
            new Display("door"),
            new PhysicsCollision(false,null,[]),
            new Fixed(),
            new Door(false,""),
            new State(['closed','open'],0,["doorA"]),
            new Active()
        ],"door");        

        var doorSwitch = engine.createEntity([
            new Position((5*32)+8,(2*32)+10),  
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
            ],"teleporter") ;
 
        engine.createEntity([ 
            new Position(18.5*32,2.5*32),  
            new Extents(16,16),
            new Display("insects","hive"), 
            new PhysicsCollision(false,null,[]),
            new Fixed(),
            new Active(),
            new exile.components.BeeHive(5)
        ],"BeeHive"); 


        // var body = new glaze.physics.Body(new Material());

        engine.createEntity([
            new Position(10*32,4*32),  
            new Extents(4,4),
            new Display("items","rock"), 
            new PhysicsCollision(false,new Filter(),[]),
            new Moveable(),
            new PhysicsBody(new Body(null,30)),
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

        engine.createEntity([
            new Position(3.5*32,1.5*32),  
            new Display("insects","hive"), 
            new Extents(5,7),
            new PhysicsCollision(false,playerFilter,[]),
            new Fixed(),
            new Active()
        ],"turret");  

        // var graph = new glaze.ai.navigation.Graph();
        // graph.pathfinder = new AStar();
        // var nodes = tmxMap.getObjectGroup("Waypoints");
        // for (node in nodes.objects) {
        //     var pl:Array<Vector2> = node.polyline;
        //     if (pl!=null) {
        //         var a:glaze.ai.navigation.Node = graph.GetCreateNode(Std.int(pl[0].x*2),Std.int(pl[0].y*2));
        //         var b:glaze.ai.navigation.Node;
        //         for (i in 1...pl.length) {
        //             b = graph.GetCreateNode(Std.int(pl[i].x*2),Std.int(pl[i].y*2));
        //             a.connect(b);
        //             a = b;
        //         }
        //     }
        // }

        // var start = graph.GetCreateNode(6*32,4*32);
        // var end = graph.GetCreateNode(2*32,13*32);
        // var route = graph.Search(start,end);
        // js.Lib.debug();     

        // var bee = exile.entities.creatures.BeeFactory.create(engine,new Position(6.1*32,4*32));
        // bee.getComponent(glaze.ai.steering.components.Steering).behaviors.push(new glaze.ai.steering.behaviors.FollowPath(route));
    }

    public function createTurret() { 

        var filter = new Filter();
        // filter.categoryBits = ExileFilters.PROJECTILE_CAT;
        filter.groupIndex = ExileFilters.TURRET_GROUP;

        var behavior = new glaze.ai.behaviortree.Sequence();   
        behavior.addChild(new glaze.engine.actions.Delay(600,100));
        behavior.addChild(new glaze.engine.actions.InitEntityCollection());
        behavior.addChild(new glaze.engine.actions.QueryEntitiesInArea(200));
        behavior.addChild(new glaze.engine.actions.SortEntities(glaze.ds.EntityCollectionItem.SortClosestFirst));
        behavior.addChild(new glaze.engine.actions.FilterEntities([filterSupport.FilterStaticItems,filterSupport.FilterVisibleAgainstMap]));
        behavior.addChild(new glaze.ai.behaviortree.Action("fireBulletAtEntity",this));
        var turret = engine.createEntity([
            mapPosition(25,1.5),
            // new Position(27*32,9.3*32),  
            new Display("enemies","turret"), 
            new Extents(12,12),  
            new PhysicsCollision(false,filter,[]),
            new Fixed(),
            new Script(behavior), 
            new Active()
        ],"turret");        
        turret.getComponent(Display).displayObject.rotation=Math.PI;
    }
          
    public function fireBullet(pos:Vector2,target:Vector2):Void {
        var filter = new Filter();
        // filter.categoryBits = ExileFilters.PROJECTILE_CAT;
        filter.groupIndex = ExileFilters.TURRET_GROUP;

        var bullet = exile.entities.projectile.StandardBulletFactory.create(engine,new Position(pos.x,pos.y),filter,target);
        // glaze.util.Ballistics.calcProjectileVelocity(bullet.getComponent(PhysicsBody).body,target,velocity);        
    }    
    
    function fireBulletAtEntity(context:glaze.ai.behaviortree.BehaviorContext) {
        var ec:glaze.ds.EntityCollection = untyped context.data.ec;
        if (ec.length==0) return;
        fireBullet(
            context.entity.getComponent(Position).coords.clone(),
            ec.entities.head.entity.getComponent(Position).coords.clone());  
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
    public function throwWabbits() {
        for (i in 0 ... 10) {
            var pos = player.getComponent(Position).clone();
            var wabbit = exile.entities.creatures.RabbitFactory.create(engine,pos);
            // var wabbit = exile.entities.creatures.MaggotFactory.create(engine,pos);
            wabbit.getComponent(PhysicsBody).body.addForce(new Vector2(RandomInteger(-1000,1000),RandomInteger(-1000,100)));
  
        }   
    }  
   
    public function destroyChickens() { 
        var cs:ChickenSystem = cast engine.getSystem(ChickenSystem);
        var explosion:Explosion = new Explosion(10,50);
        var entity = cs.view.entities[0]; 
        if (entity!=null) {
            entity.addComponent(new Destroy(1)); 
            explosion.update(1,entity,blockParticleEngine,spriteParticleEngine);
        } else {
            killChickens = false;         
        }    
    }      
    override public function preUpdate() {   
        // js.Lib.debug();  
        // if (false){     
            // if (input.JustPressed(65)) {
                // trace(glaze.util.Random.RandomInteger(0,2));
        // if (glaze.util.Random.RandomBool ean(0.01)) {   
            // spriteParticleEngine.EmitParticle(100,100,glaze.util.Random.RandomFloat(-10,10),glaze.util.Random.RandomFloat(-10,10),0,0,2000,1,true,true,null,0,16,0,0,0);
            // spriteParticleEngine.EmitParticle(130,100,glaze.util.Random.RandomFloat(-10,10),glaze.util.Random.RandomFloat(-10,10),0,0,2000,1,true,true,null,1,32,0,0,0);
            // spriteParticleEngine.EmitParticle(100,130,glaze.util.Random.RandomFloat(-10,10),glaze.util.Random.RandomFloat(-10,10),0,0,2000,1,true,true,null,2,32,0,0,0);
            // spriteParticleEngine.EmitParticle(130,130,glaze.util.Random.RandomFloat(-10,10),glaze.util.Random.RandomFloat(-10,10),0,0,2000,1,true,true,null,3,32,0,0,0);
            // spriteParticleEngine.EmitParticle(100,160,glaze.util.Random.RandomFloat(-10,10),glaze.util.Random.RandomFloat(-10,10),0,0,2000,1,true,true,null,4,32,0,0,0);
            // spriteParticleEngine.EmitParticle(130,160,glaze.util.Random.RandomFloat(-10,10),glaze.util.Random.RandomFloat(-10,10),0,0,2000,1,true,true,null,5,32,0,0,0);
            // spriteParticleEngine.EmitParticle(50,190,glaze.util.Random.RandomFloat(-10,10),glaze.util.Random.RandomFloat(-10,10),0,0,2000,1,true,true,null,6,32,0,0,0);            
            // spriteParticleEngine.EmitParticle(100,190,glaze.util.Random.RandomFloat(-40,40),glaze.util.Random.RandomFloat(-40,40),0,0,2000,1,true,true,null,8,32,glaze.util.Random.RandomSign(0.5),glaze.util.Random.RandomSign(0.5),0);              
        // }          
        // trace(nf.collideCount);
        // nf.collideCount=0;  
        input.Update(-renderSystem.camera.position.x,-renderSystem.camera.position.y);
        if (killChickens) { 
            destroyChickens();
        }       
        if (shakeIt>1) {
            trace("shakeit");
            renderSystem.camera.shake.setTo(glaze.util.Random.RandomFloat(-shakeIt,shakeIt),glaze.util.Random.RandomFloat(-shakeIt,shakeIt)); 
            shakeIt*=0.9;
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
        Browser.document.getElementById("debug4button").addEventListener("click",function(event){
            game.shakeIt = 15;
        });        
        Browser.document.getElementById("debug5button").addEventListener("click",function(event){
            // game.shakeIt = false;
            game.throwWabbits();
        });        
        Browser.document.getElementById("entities").addEventListener("click",function(event){
            untyped Browser.window.writeResult(glaze.debug.DebugEngine.GetAllEntities());
        });
        Browser.document.getElementById("systems").addEventListener("click",function(event){
            untyped Browser.window.writeResult(glaze.debug.DebugEngine.GetAllSystems());
        });

    }   

}