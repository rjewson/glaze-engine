package glaze.ai.faction;

import glaze.ai.faction.FactionRelationship;
import glaze.eco.core.IComponent;
import haxe.ds.StringMap;

class Faction {
	
	public var id:String;

	public var type:String;

	public var relationships:StringMap<FactionRelationship>;

	public var defaultRelationship:FactionRelationship;

	public function new(id:String,type:String,defaultRelationshipStatus:Int = 0) {
		this.id = id;
		this.type = type;
		relationships = new StringMap<FactionRelationship>();
		defaultRelationship = new FactionRelationship(null,defaultRelationshipStatus);	    
	}

	public function addRelation(relation:FactionRelationship) {
	    relationships.set(relation.relation.id,relation);
	}

	public function compareTo(other:Faction):FactionRelationship {
		var result = relationships.get(other.id);
		return (result==null) ? defaultRelationship : result;
	}

}