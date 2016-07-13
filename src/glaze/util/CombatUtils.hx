package glaze.util;

import glaze.ai.faction.components.Personality;
import glaze.ai.faction.Faction;
import glaze.ds.EntityCollection;
import glaze.ds.EntityCollectionItem;
import glaze.eco.core.Entity;
import glaze.engine.components.Destroy;
import glaze.engine.components.Health;
import glaze.geom.Vector2;
import glaze.physics.collision.broadphase.IBroadphase;
import glaze.physics.collision.Ray;
import glaze.physics.components.PhysicsBody;
import glaze.util.BroadphaseAreaQuery;

enum EntityFilterOptions {
    ALL;
    FRIENDLY;
    ENEMY;
}

class CombatUtils {

	public static var bfAreaQuery:glaze.util.BroadphaseAreaQuery;
	public static var broadphase:IBroadphase;
    public static var ray:Ray;
    public static var referenceEntity:Entity;

	public function new() {
		
	}

	public static function setBroadphase(bf:IBroadphase) {
		CombatUtils.broadphase = bf;
		CombatUtils.bfAreaQuery = new BroadphaseAreaQuery(bf);
        CombatUtils.ray = new Ray();
	}

    public static function canSee(start:Vector2,end:Vector2,range:Float):Bool {
        if (start.distSqrd(end)>=range*range)
            return false;
        ray.initalize(start,end,0,null);
        trace("looking",start,end);
        broadphase.CastRay(ray,null,false,false);
        return !ray.hit;
    }

    public static function searchSortAndFilter(position:Vector2,radius:Float,referenceEntity:Entity,filterOptions:EntityFilterOptions):EntityCollection {
        CombatUtils.referenceEntity = referenceEntity;
        CombatUtils.bfAreaQuery.query(position,radius,referenceEntity,true);
        CombatUtils.bfAreaQuery.entityCollection.entities.sort(glaze.ds.EntityCollectionItem.SortClosestFirst);
        CombatUtils.bfAreaQuery.entityCollection.filter(FilterItems);
        if (filterOptions==EntityFilterOptions.ENEMY)
            CombatUtils.bfAreaQuery.entityCollection.filter(FilterEnemyFactions);
        else if (filterOptions==EntityFilterOptions.FRIENDLY)
            CombatUtils.bfAreaQuery.entityCollection.filter(FilterFriendlyFactions);

        return CombatUtils.bfAreaQuery.entityCollection;
    }

    public static function FilterItems(eci:EntityCollectionItem):Bool {
        return ( eci.entity.getComponent(glaze.engine.components.Fixed)==null || eci.entity.getComponent(glaze.engine.components.Destroy)==null );
    }


    public static function FilterEnemyFactions(eci:EntityCollectionItem):Bool {
        var faction = eci.entity.getComponent(Personality);
        if (faction==null)
            return false;
        var refFaction = CombatUtils.referenceEntity.getComponent(Personality);
        if (refFaction==null)
            return false;
        return refFaction.faction.compareTo(faction.faction).status<0;
    }

    public static function FilterFriendlyFactions(eci:EntityCollectionItem):Bool {
        var faction = eci.entity.getComponent(Personality);
        if (faction==null)
            return false;
        var refFaction = CombatUtils.referenceEntity.getComponent(Personality);
        if (refFaction==null)
            return false;
        return refFaction.faction.compareTo(faction.faction).status>0;
    }


	public static function explode(position:Vector2,radius:Float,power:Float,sourceEntity:Entity) {
	    CombatUtils.bfAreaQuery.query(position,radius,sourceEntity,true);
	    var item = CombatUtils.bfAreaQuery.entityCollection.entities.head;
        while (item!=null) {
            if (item.entity.getComponent(Destroy)==null) {

                var health = item.entity.getComponent(Health);
                var body = item.entity.getComponent(PhysicsBody);

                if (health!=null || body!=null) {
                    var effect = (radius/Math.sqrt(item.distance))*power;
                    trace(item.distance);
                    trace('e=$effect');
                    if (health!=null) {
                        health.applyDamage(effect);
                    }
                    
                    var personality = item.entity.getComponent(Personality);
                    if (personality!=null) {
                        personality.applyDamage(sourceEntity,"explosion",effect);
                    }

                    if (body!=null) {
                        var delta = body.body.position.clone();
                        delta.minusEquals(position);
                        delta.normalize();
                        delta.multEquals(effect);
                        body.body.addForce(delta);
                    }               
                }
            }
            item = item.next;
        }
	}

}