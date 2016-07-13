package glaze.util;

import glaze.eco.core.Entity;
import glaze.engine.components.Destroy;
import glaze.engine.components.Position;
import glaze.geom.Vector2;
import glaze.physics.Body;

class EntityUtils {

    public static function standardDestroy(entity:Entity) {
        entity.addComponent(new Destroy(1));
    }

}