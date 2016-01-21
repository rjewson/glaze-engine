
package glaze.physics.collision;

import glaze.ds.Bytes2D;
import glaze.geom.Plane;
import glaze.geom.Vector2;
import glaze.physics.collision.BFProxy;
import glaze.physics.collision.Contact;
import glaze.physics.collision.Intersect;
import glaze.physics.collision.Ray;

class Map 
{

    public static inline var COLLIDABLE:Int = 0x1 << 0;
    public static inline var ONE_WAY:Int    = 0x1 << 1;

    public static inline var CORRECTION:Float = .0;
    public static inline var ROUNDDOWN:Float = .01;
    public static inline var ROUNDUP:Float = .5;

    public var tileSize:Float;
    public var tileHalfSize:Float;

    public var data:Bytes2D;

    public var tilePosition:Vector2 = new Vector2();
    public var tileExtents:Vector2 = new Vector2();
    public var bias:Vector2 =  new Vector2(1,1);
    public var plane:Plane = new Plane();

    public var contact:Contact;
    public var closestContact:Contact;

    public var debug:Int->Int->Void; 

    public function new(data:Bytes2D) {
        this.data = data;
        tileSize = data.cellSize;
        tileHalfSize = tileSize/2;
        tileExtents.setTo(tileHalfSize,tileHalfSize);
        contact = new Contact();
        closestContact = new Contact();
    }

    public function testCollision(proxy:BFProxy) {

        var body = proxy.body;

        var startX = data.Index(Math.min(body.position.x,body.predictedPosition.x) - proxy.aabb.extents.x - CORRECTION);
        var startY = data.Index(Math.min(body.position.y,body.predictedPosition.y) - proxy.aabb.extents.y - CORRECTION);

        var endX = data.Index(Math.max(body.position.x,body.predictedPosition.x) + proxy.aabb.extents.x + CORRECTION - ROUNDDOWN) + 1;
        var endY = data.Index(Math.max(body.position.y,body.predictedPosition.y) + proxy.aabb.extents.y + CORRECTION ) + 1;


        if (body.isBullet) {
            plane.setFromSegment(body.predictedPosition,body.position);
            closestContact.time = Math.POSITIVE_INFINITY;
            for (x in startX...endX) {
                for (y in startY...endY) { 
                    var cell = data.get(x,y,1);
                    if (cell&COLLIDABLE==1) {
                        tilePosition.x = (x*tileSize)+tileHalfSize;
                        tilePosition.y = (y*tileSize)+tileHalfSize;
                        if (Math.abs(plane.distancePoint(tilePosition))<40) {
                            if (Intersect.StaticAABBvsSweeptAABB(tilePosition,tileExtents,body.position,proxy.aabb.extents,body.delta,contact)==true) {
                                if (body.respondBulletCollision(contact)) {
                                    closestContact.setTo(contact);
                                }
                            }                            
                        }
                    }
                }
            }
            if (closestContact.time<Math.POSITIVE_INFINITY) {
                proxy.collide(null,contact);
            }
        } else {
            for (x in startX...endX) {
                for (y in startY...endY) { 
                    var cell = data.get(x,y,1);
                    if (cell&COLLIDABLE==1) {
                        tilePosition.x = (x*tileSize)+tileHalfSize;
                        tilePosition.y = (y*tileSize)+tileHalfSize;
                        if (Intersect.AABBvsStaticSolidAABB(body.position,proxy.aabb.extents,tilePosition,tileExtents,bias,contact)==true) {
                            var nextX:Int = x + Std.int(contact.normal.x);
                            var nextY:Int = y + Std.int(contact.normal.y);
                            var nextCell = data.get(nextX,nextY,1);
                            if (nextCell&COLLIDABLE==0) {
                                body.respondStaticCollision(contact);
                                proxy.collide(null,contact);
                            } 
                        }
                    }
                }
            }
        }

        // plane.setFromSegment(body.predictedPosition,body.position);

        // for (x in startX...endX) {
        //     for (y in startY...endY) { 
        //         var cell = data.get(x,y,1);
        //         if (cell&COLLIDABLE==1) {
        //             tilePosition.x = (x*tileSize)+tileHalfSize;
        //             tilePosition.y = (y*tileSize)+tileHalfSize;

        //             if (body.isBullet) {
        //                 //FIXME
        //                 if (Math.abs(plane.distancePoint(tilePosition))<40) {
        //                     if (Intersect.StaticAABBvsSweeptAABB(tilePosition,tileExtents,body.position,proxy.aabb.extents,body.delta,contact)==true) {
        //                         body.respondBulletCollision(contact);
        //                         if (proxy.contactCallback!=null) {
        //                             proxy.contactCallback(proxy,null,contact);
        //                         }
        //                     }                            
        //                 }
        //             } else {
        //                 if (Intersect.AABBvsStaticSolidAABB(body.position,proxy.aabb.extents,tilePosition,tileExtents,contact)==true) {
        //                     var nextX:Int = x + Std.int(contact.normal.x);
        //                     var nextY:Int = y + Std.int(contact.normal.y);
        //                     var nextCell = data.get(nextX,nextY,1);
        //                     if (nextCell&COLLIDABLE==0) {
        //                         body.respondStaticCollision(contact);
        //                         if (proxy.contactCallback!=null) {
        //                             proxy.contactCallback(proxy,null,contact);
        //                         }
        //                     } else {
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
    }

    public function castRay(ray:Ray):Bool {

        var x = data.Index(ray.origin.x);
        var y = data.Index(ray.origin.y);
        var cX = x*tileSize;
        var cY = y*tileSize;
        var d = ray.direction;
        if (d.x==0.0&&d.y==0.0)
            return true;
        var stepX:Int       = 0;
        var tMaxX:Float     = 100000000;
        var tDeltaX:Float   = 0;
        if (d.x < 0) {
            stepX = -1;
            tMaxX = (cX - ray.origin.x) / d.x;
            tDeltaX = tileSize / -d.x;
        } else if (d.x > 0) {
            stepX = 1;
            tMaxX = ((cX + tileSize) - ray.origin.x) / d.x;
            tDeltaX = tileSize / d.x;
        } 

        var stepY:Int       = 0; 
        var tMaxY:Float     = 100000000;
        var tDeltaY:Float   = 0;
        if (d.y < 0) {
            stepY = -1;
            tMaxY = (cY - ray.origin.y) / d.y;
            tDeltaY = tileSize / -d.y;
        } else if (d.y > 0) {
            stepY = 1;
            tMaxY = ((cY + tileSize) - ray.origin.y) / d.y;
            tDeltaY = tileSize / d.y;
        } 

        var distX = .0;
        var distY = .0;

        var transitionEdgeNormalX = 0;
        var transitionEdgeNormalY = 0;

        while (true) {

            if (tMaxX < tMaxY) {
                distX += tMaxX * d.x;
                distY += tMaxX * d.y;
                tMaxX += tDeltaX;
                x += stepX;
            } else {
                distX += tMaxY * d.x;
                distY += tMaxY * d.y;
                tMaxY += tDeltaY;
                y += stepY;
            }

            if (distX*distX+distY*distY>ray.range*ray.range)
                return false;

            var tile = data.get(x,y,0);
            if (tile>0) {
                if (tMaxX < tMaxY) {
                    transitionEdgeNormalX = (stepX < 0) ? 1 : -1;
                    transitionEdgeNormalY = 0;
                } else {
                    transitionEdgeNormalX = 0;
                    transitionEdgeNormalY = (stepY < 0) ? 1 : -1;
                }
                ray.report(distX,distY,transitionEdgeNormalX,transitionEdgeNormalY);
                return true;
            }
        }

        return false;
    }

}