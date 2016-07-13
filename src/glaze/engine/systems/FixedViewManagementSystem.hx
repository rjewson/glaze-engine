package glaze.engine.systems;

import glaze.eco.core.Entity;
import glaze.eco.core.System;
import glaze.engine.components.Extents;
import glaze.engine.components.Fixed;
import glaze.engine.components.Position;
import glaze.engine.components.Viewable;
import glaze.engine.managers.space.ISpaceManager;
import glaze.engine.managers.space.RegularGridSpaceManager;
import glaze.render.display.Camera;

class FixedViewManagementSystem extends System {

    var camera:Camera;
    var spaceManager:ISpaceManager;
    var activeSpaceAABB:glaze.geom.AABB;

    public function new(camera:Camera) {
        this.camera = camera;
        super([Position,Extents,Fixed]);
        spaceManager = new RegularGridSpaceManager(10,10,500);
        activeSpaceAABB = new glaze.geom.AABB();
        activeSpaceAABB.extents.setTo(800/2, 600/2);
    }

    override public function entityAdded(entity:Entity) {
        spaceManager.addEntity(entity);
    }

    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        activeSpaceAABB.position.copy(camera.realPosition);
        spaceManager.search(activeSpaceAABB,setEntityStatus);
    }

    function setEntityStatus(entity:Entity,status:Bool) {
        if (status==true) {
            entity.addComponent(new Viewable());
            // trace(entity.name+" is viewable");
        }
        else {
            entity.removeComponent(entity.getComponent(Viewable));
            // trace(entity.name+" is not viewable now");
        }
    }

}