package glaze.ds;

import glaze.ds.EntityCollection;
import glaze.eco.core.Entity;
import glaze.ds.EntityCollectionItem;

class EntityCollection 
{

    public static var itempool = {
        var pool = new glaze.ds.DLL<EntityCollectionItem>();
        pool;
    }

    public var entities:glaze.ds.DLL<EntityCollectionItem>;

    public var length(get, never):Int;

    public function new() {
        entities = new glaze.ds.DLL<EntityCollectionItem>();
    }

    private inline function get_length():Int {
        return entities.length;
    }

    public function addItem(entity:Entity):EntityCollectionItem {
        var item;
        if (EntityCollection.itempool.length==0) {
            item = new EntityCollectionItem();
        } else {
            item = EntityCollection.itempool.remove(EntityCollection.itempool.tail);
        }
        item.entity = entity;
        entities.insertBeginning(item);
        return item;
    }

    public function getItem(entity:Entity):EntityCollectionItem {
        var item = entities.head;
        while (item!=null) {
            if (item.entity==entity)
                return item;
        }        
        return null;
    }

    public inline function removeItem(item:EntityCollectionItem):Void {
        item.reset();
        EntityCollection.itempool.insertEnd(item);
    }

    public function filter(filterFunc:ECIFilter) {
        var eci = entities.head;
        while (eci!=null) {
            if (filterFunc(eci)==false) {
                var next = eci.next;
                entities.remove(eci);
                eci = next;
            } else {
                eci =eci.next;
            }
        }
    }

    public function clear() {
        while (entities.length>0) {
            removeItem(entities.remove(entities.tail));
        }
    }

}