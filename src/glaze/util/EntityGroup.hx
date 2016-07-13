package glaze.util;

import glaze.eco.core.Entity;
import glaze.engine.components.Destroy;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.Body;
import glaze.signals.Signal2;

enum GroupEvent {
	MemberAdded;
	MemberRemoved;
}

class EntityGroup {

	// public var groupManager:Entity;  
	public var members:Array<Entity>;
	public var maxMembers:Int; 
	public var messages:Signal2<GroupEvent,Entity>;

    public function new(maxMembers:Int):Void  {
        // this.groupManager = groupManager;
        this.maxMembers = maxMembers;
        this.members = new Array<Entity>();
        this.messages = new Signal2<GroupEvent,Entity>();
    }

    public function addMember(entity:Entity) {
    	if (!hasCapacity())
    		return;
    	members.push(entity);
    	entity.messages.add(onMemberMessage);
    	messages.dispatch(GroupEvent.MemberAdded,entity);
    } 

    public function removeMember(entity:Entity) {
    	 if (members.remove(entity))
    	 	messages.dispatch(GroupEvent.MemberRemoved,entity);
    }

    public function onMemberMessage(e:Entity,type:String,data:Dynamic) {
    	switch (type) {
    		case Entity.DESTROY:
    			removeMember(e);
    	}
    }

    public function hasCapacity():Bool {
    	return members.length<maxMembers;
    }


}