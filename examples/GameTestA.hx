package;

import glaze.engine.components.Display;
import glaze.engine.components.ParticleEmitters;
import glaze.engine.components.Physics;
import glaze.engine.components.Position;
import glaze.eco.core.Engine;
import glaze.engine.components.Script;
import glaze.engine.core.GameEngine;
import glaze.engine.systems.BehaviourSystem;
import glaze.engine.systems.ParticleSystem;
// import glaze.engine.systems.PhysicsSystem;
import glaze.geom.Vector2;
import glaze.engine.systems.RenderSystem;
import glaze.particle.BlockSpriteParticleEngine;
import glaze.particle.emitter.RandomSpray;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.broadphase.BruteforceBroadphase;
import glaze.physics.collision.Map;
import glaze.physics.components.PhysicsBody;
import glaze.physics.components.PhysicsCollision;
import glaze.physics.Material;
import glaze.physics.systems.PhysicsCollisionSystem;
import glaze.physics.systems.PhysicsPositionSystem;
import glaze.physics.systems.PhysicsUpdateSystem;
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

    public function new() {
        super(cast(Browser.document.getElementById("view"),CanvasElement));
        loadAssets([MAP_DATA,TEXTURE_CONFIG,TEXTURE_DATA,TILE_SPRITE_SHEET,TILE_MAP_DATA_1,TILE_MAP_DATA_2]);
    }

    override public function initalize() {

        setupMap();

        var corephase = engine.createPhase();
        var aiphase = engine.createPhase(1000);
        var physicsPhase = engine.createPhase(1000/60);

        var renderSystem = new RenderSystem(canvas);
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

        aiphase.addSystem(new BehaviourSystem());
        corephase.addSystem(new ParticleSystem(blockParticleEngine));
        corephase.addSystem(renderSystem);
        
        var behavior = new glaze.ai.behaviortree.Sequence();
        behavior.addChild(new glaze.engine.actions.LogAction());

        var body = new glaze.physics.Body(new Material());
        var proxy = new glaze.physics.collision.BFProxy(30/2,72/2,null);
        proxy.setBody(body);

        var player = engine.create([
            new Position(100,100),
            new Display("character1.png"),
            new PhysicsBody(body),
            new PhysicsCollision(proxy),
            new Script(behavior),
            new ParticleEmitters([new RandomSpray(0,10)])
        ]);
        var playerBody = player.getComponent(PhysicsBody).body;

        characterController = new CharacterController(input,playerBody);
        playerBody.maxScalarVelocity = 0;
        playerBody.maxVelocity.setTo(160,1000);

        renderSystem.CameraTarget(player.getComponent(Position).coords);

    }

    function setupMap() {
        tmxMap = new glaze.tmx.TmxMap(assets.assets.get(MAP_DATA));
        tmxMap.tilesets[0].set_image(assets.assets.get(TILE_SPRITE_SHEET));
    }

    override public function preUpdate() {
        characterController.update();
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