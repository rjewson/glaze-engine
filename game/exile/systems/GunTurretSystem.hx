package exile.systems;

import exile.components.GunTurret;
import glaze.ds.EntityCollectionItem;
import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.collision.Filter;

class GunTurretSystem extends System {

    public function new() {
        super([GunTurret,Position]);
    }

    override public function entityAdded(entity:Entity) {        
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        for (entity in view.entities) {
            var turret = entity.getComponent(GunTurret);
            var position = entity.getComponent(Position);
            if (turret.intervalDelay.tick(delta)) {
                var entities = glaze.util.CombatUtils.searchSortAndFilter(position.coords,400,entity,glaze.util.CombatUtils.EntityFilterOptions.ENEMY).entities;
                if (entities.head!=null) {
                    fireBulletAtEntity(position,entities.head.entity);
                }
            }
        }
    }
    
    function fireBulletAtEntity(position:Position,target:Entity) {
        fireBullet(
            position.coords.clone(),
            target.getComponent(Position).coords.clone()
        );  
    }

    public function fireBullet(pos:Vector2,target:Vector2):Void {
        var filter = new Filter();
        filter.groupIndex = ExileFilters.TURRET_GROUP;
        var bullet = exile.entities.projectile.StandardBulletFactory.create(engine,new Position(pos.x,pos.y),filter,target);
    }    

}