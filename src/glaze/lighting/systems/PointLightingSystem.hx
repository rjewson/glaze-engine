package glaze.lighting.systems;

import glaze.ds.Bytes2D;
import glaze.eco.core.System;
import glaze.engine.components.Position;
import glaze.eco.core.Entity;
import glaze.engine.components.Viewable;
import glaze.engine.managers.space.ISpaceManager;
import glaze.geom.Vector2;
import glaze.lighting.components.Light;
import glaze.physics.collision.Map;
import glaze.render.renderers.webgl.FBOLighting;
import glaze.util.Maths.Clamp;

class PointLightingSystem extends System {
    
    public var renderer:FBOLighting;

    public var map:Map;

    public function new(map:Map) {
        super([Position,Light,Viewable]);
        this.map = map;
        renderer = new FBOLighting();
    }

    override public function entityAdded(entity:Entity) {
    }
    
    override public function entityRemoved(entity:Entity) {
    }

    override public function update(timestamp:Float,delta:Float) {
        renderer.reset();
        for (entity in view.entities) {
            var position = entity.getComponent(Position);
            var light = entity.getComponent(Light);
            if (light.flicker>0) {
                light.intensity = nexLightIntensity(light.intensity);
                renderer.addLight(position.coords.x+glaze.util.Random.RandomFloat(-3,3),position.coords.y+glaze.util.Random.RandomFloat(-3,3),light.range*light.intensity,light.red,light.green,light.blue);
            } else {
                renderer.addLight(position.coords.x,position.coords.y,light.range*light.intensity,light.red,light.green,light.blue);
            }
        } 
        // trace("Rendered "+view.entities.length+" lights");
    }

    function nexLightIntensity(lastIntensity:Float) {
        return Clamp(lastIntensity+(Math.random()-0.3)/10,0,1);
    }

}