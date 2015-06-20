package;

import glaze.eco.core.Entity;
import glaze.engine.components.Display;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Position;
import glaze.eco.core.Engine;
import glaze.engine.components.Script;
import glaze.engine.core.GameEngine;
import glaze.engine.systems.BehaviourSystem;
import glaze.engine.systems.ParticleSystem;
// import glaze.engine.systems.PhysicsSystem;
import glaze.geom.Vector2;
import glaze.engine.systems.RenderSystem; 
import glaze.lighting.components.Light;
import glaze.particle.BlockSpriteParticleEngine;
import glaze.particle.emitter.RandomSpray;
import glaze.physics.Body;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.BruteforceBroadphase;
import glaze.physics.collision.Filter;
import glaze.physics.collision.Map;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.physics.systems.PhysicsCollisionSystem;
import glaze.physics.systems.PhysicsPositionSystem;
import glaze.physics.systems.PhysicsUpdateSystem;
import glaze.render.renderers.webgl.FBOLighting;
import glaze.render.renderers.webgl.SpriteRenderer;
import glaze.render.renderers.webgl.TileMap;
import glaze.tmx.TmxMap;
import js.Browser;
import js.html.CanvasElement;
import util.CharacterController;

class GameTestA extends GameEngine {
     
    public static inline var MAP_DATA:String = "data/testMap.tmx";
    public static inline var TEXTURE_CONFIG:String = "data/sprites.json";
    public static inline var TEXTURE_DATA:String = "data/sprites.png";

    public static inline var TILE_SPRITE_SHEET:String = "data/spelunky-tiles.png";
    public static inline var TILE_MAP_DATA_1:String = "data/spelunky0.png";
    public static inline var TILE_MAP_DATA_2:String = "data/spelunky1.png";

    var tmxMap:TmxMap;
    var characterController:CharacterController; 
    var player:Entity;
    var playerFilter:Filter;
    var renderSystem:RenderSystem;    

    public function new() {
        super(cast(Browser.document.getElementById("view"),CanvasElement));
        loadAssets([MAP_DATA,TEXTURE_CONFIG,TEXTURE_DATA,TILE_SPRITE_SHEET,TILE_MAP_DATA_1,TILE_MAP_DATA_2]);
    }

    override public function initalize() {
    
        setupMap();

        var corephase = engine.createPhase(); 
        var aiphase = engine.createPhase(1000/30);
        var physicsPhase = engine.createPhase(1000/60);
             
        renderSystem = new RenderSystem(canvas);
        renderSystem.textureManager.AddTexture(TEXTURE_DATA, assets.assets.get(TEXTURE_DATA) );
        renderSystem.textureManager.ParseTexturePackerJSON( assets.assets.get(TEXTURE_CONFIG) , TEXTURE_DATA );
        
        var mapData = glaze.tmx.TmxLayer.LayerToCoordTexture(tmxMap.getLayer("Tile Layer 1"));
        
        var tileMap = new TileMap();
        renderSystem.renderer.AddRenderer(tileMap);
        tileMap.SetSpriteSheet(assets.assets.get(TILE_SPRITE_SHEET));
        tileMap.SetTileLayerFromData(mapData,"base",1,1);
        tileMap.SetTileLayer(assets.assets.get(TILE_MAP_DATA_2),"bg",0.6,0.6);
        tileMap.tileSize = 16;
        tileMap.TileScale(2); 
       
        var spriteRender = new SpriteRenderer();
        spriteRender.AddStage(renderSystem.stage);
        renderSystem.renderer.AddRenderer(spriteRender);
 
        var blockParticleEngine = new BlockSpriteParticleEngine(4000,1000/60);
        renderSystem.renderer.AddRenderer(blockParticleEngine.renderer);
 
        var map = new Map(tmxMap.getLayer("Tile Layer 1").tileGIDs); 
        physicsPhase.addSystem(new PhysicsUpdateSystem());
        physicsPhase.addSystem(new PhysicsCollisionSystem(new BruteforceBroadphase(map,new glaze.physics.collision.Intersect())));
        physicsPhase.addSystem(new PhysicsPositionSystem());
                

        /*
         * Lighting RnD
         */
        // var lightSystem = new glaze.lighting.systems.LightingSystem(map);
        // renderSystem.renderer.AddRenderer(lightSystem.renderer);
        var lightSystem = new glaze.lighting.systems.PointLightingSystem(map);
        renderSystem.renderer.AddRenderer(lightSystem.renderer);
        // var fboLighting = new FBOLighting();
        // renderSystem.renderer.AddRenderer(fboLighting);

        aiphase.addSystem(new BehaviourSystem());                                                   

        corephase.addSystem(new ParticleSystem(blockParticleEngine));
        corephase.addSystem(lightSystem);
        corephase.addSystem(renderSystem);
         
        playerFilter = new Filter();
        playerFilter.groupIndex = 1; 

        var body = new glaze.physics.Body(new Material());
        body.maxScalarVelocity = 0;
        body.maxVelocity.setTo(160,1000);
        var proxy = new glaze.physics.collision.BFProxy(30/2,72/2,playerFilter);
        proxy.setBody(body);
        characterController = new CharacterController(input,body);
           
        player = engine.createEntity([
            new Position(300,180),
            new Display("character1.png"),
            new PhysicsBody(body),
            new PhysicsCollision(proxy) 
        ]); 

        renderSystem.CameraTarget(player.getComponent(Position).coords);
 
        var light = engine.createEntity( 
            [  
            player.getComponent(Position), 
            //new Position(100,100),
            new Light(256,1,1,0)
            ]); 
             
    } 

    function setupMap() {
        tmxMap = new glaze.tmx.TmxMap(assets.assets.get(MAP_DATA));
        tmxMap.tilesets[0].set_image(assets.assets.get(TILE_SPRITE_SHEET));
    } 
 
          
    public function fireBullet():Void  
    {
        var bulletBody = new Body(new Material());
        bulletBody.setMass(0.03);
        bulletBody.setBounces(3);     

        bulletBody.isBullet = true;
        bulletBody.maxScalarVelocity = 3000; 
  
        var bulletProxy = new glaze.physics.collision.BFProxy(3,3,playerFilter);
        bulletProxy.setBody(bulletBody);

        var pos = player.getComponent(Position).coords.clone();
         
        var vel = input.ViewCorrectedMousePosition() ;
        vel.minusEquals(pos);
        vel.normalize();
        vel.multEquals(1000); 
        bulletBody.velocity.setTo(vel.x,vel.y);
            
        var behavior = new glaze.ai.behaviortree.Sequence();
        behavior.addChild(new glaze.engine.actions.Delay(1000));
        behavior.addChild(new glaze.engine.actions.DestroyEntity());
 
        var bullet = engine.createEntity([
            new Position(pos.x,pos.y), 
            new Display("projectile1.png"), 
            new PhysicsBody(bulletBody), 
            new PhysicsCollision(bulletProxy),  
            // new ParticleEmitters([new RandomSpray(0,30)])
            new ParticleEmitters([new glaze.particle.emitter.InterpolatedEmitter(0,10)]),
            new Script(behavior),
            new Light(64,1,1,1)         
        ]);              
         
    }  
  
    override public function preUpdate() {
      
        //TODO find somewhere better for this 
        characterController.update(); 
      
        var fire = input.JustPressed(32);
        var search = input.JustPressed(71);
        var debug = input.Pressed(72); 
        var ray = input.Pressed(82);
        
        if (fire) fireBullet();

        input.Update(-renderSystem.camera.position.x,-renderSystem.camera.position.y);

    }

    public static function main() {
        var game = new GameTestA();

        Browser.document.getElementById("stopbutton").addEventListener("click",function(event){
            game.loop.stop();
        });
        Browser.document.getElementById("startbutton").addEventListener("click",function(event){
            game.loop.start();
        });
    }   

}