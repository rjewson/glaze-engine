package glaze.ai.faction;

import glaze.ai.faction.Faction;

class FactionRelationship {
	
	public var relation:Faction;

	public var status:Int = 0;

	public function new(relation:Faction,status:Int) {
	    this.relation = relation;
	    this.status = status;
	}

}