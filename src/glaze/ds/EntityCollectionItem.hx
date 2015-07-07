package glaze.ds;

import glaze.ds.DLL;
import glaze.eco.core.Entity;
import glaze.geom.Vector2;

class EntityCollectionItem implements DLLNode<EntityCollectionItem>
{

    public var prev:EntityCollectionItem;
    public var next:EntityCollectionItem;

    public var entity:Entity;

    public var distance:Float;
    public var priority:Float;
    public var visible:Bool;
    public var perspective:Vector2;

    public function new() {

    }

    public function reset() {
        
    }

    public static function SortClosestFirst(a:EntityCollectionItem,b:EntityCollectionItem):Float {
        return a.distance-b.distance;
    }


}

typedef ECIComp = EntityCollectionItem->EntityCollectionItem->Float;
typedef ECIFilter = EntityCollectionItem->Bool;