package exile.entities.items;

import glaze.engine.components.Active;
import glaze.engine.components.State;
import exile.components.Door;
import glaze.engine.components.Fixed;
import glaze.physics.components.PhysicsCollision;
import glaze.engine.components.TileDisplay;
import glaze.engine.components.Extents;
import glaze.engine.components.Position;
import glaze.engine.components.ECState;
import glaze.ai.fsm.LightStateMachine.LightStateSet;

class DoorFactory {
    
    public static var id:String = "door";

    public static var states:LightStateSet = [
        "open" => function(entity:Entity) {
            var door = entity.getComponent(Door);
            var tileDisplay = entity.getComponent(TileDisplay);
            tileDisplay.tileFrameId = door.type+"Open";
            var pc = entity.getComponent(PhysicsCollision);
	        pc.proxy.responseBias.x=0;
	        pc.proxy.isActive = false;
        },
        "close" => function(entity:Entity) {
            var door = entity.getComponent(Door);
            var tileDisplay = entity.getComponent(TileDisplay);
            tileDisplay.tileFrameId = door.type+"Closed";
            var pc = entity.getComponent(PhysicsCollision);
	        pc.proxy.responseBias.x=1;
	   	    pc.proxy.isActive = true;
        }
    ];

    private function new() {
    }

    public static var create:Array<IComponent>->Array<IComponent> = function(components) {
        var extents:Extents = cast components[2];
        extents.halfWidths.y/=2;
        return components.concat([
            // new TileDisplay(),
            // new PhysicsCollision(false,null,[]),
            // new Fixed(),     
            // new Door("door"),
            // new ECState(states),
            // // new SyncGlobalState("globalStateID"), // Dynamic -> String
            // new Active()
            new TileDisplay("doorClosed"),
            new PhysicsCollision(false,null,[]),
            new Fixed(),      
            new Door("door",false,""),
            new State(['closed','open'],0,["doorA"]),
            new ECState(states,"open",["open","close"]),
            new Active()
        ]);

    }
}