
package glaze.physics;

import glaze.geom.Vector2;
import glaze.physics.collision.Contact;
import glaze.physics.Material;

class Body 
{

    public static inline var SLEEP_BIAS : Float = 0.99332805041467;
    public static inline var SLEEP_EPSILON : Float = 0.0009;
    public static inline var WAKE_MOTION : Float = 10;
    public static inline var MASS_SCALE : Float = 1/10;

    public var position:Vector2 = new Vector2();
    public var positionCorrection:Vector2 = new Vector2();
    public var predictedPosition:Vector2 = new Vector2();
    public var delta:Vector2 = new Vector2();
    public var previousPosition:Vector2 = new Vector2();

    public var velocity:Vector2 = new Vector2();
    public var originalVelocity:Vector2 = new Vector2();

    public var contactNormal:Vector2 = new Vector2();
    public var prevContactNormal:Vector2 = new Vector2();

    public var tangent:Vector2 = new Vector2();
    public var toi:Float;

    public var stepContactCount:Int = 0;

    public var maxScalarVelocity:Float = 1000;
    public var maxVelocity:Vector2 = new Vector2();

    public var material:Material;

    public var forces:Vector2 = new Vector2();
    private var accumulatedForces:Vector2 = new Vector2();

    public var isBullet:Bool = false;

    public var damping:Float = 1;
    public var globalForceFactor:Float = 1;

    public var mass:Float = 1;
    public var invMass:Float = 1;

    public var dt:Float = 0;

    public var motion:Float = WAKE_MOTION;
    public var canSleep:Bool = false;
    public var isSleeping:Bool = false;

    public var onGround:Bool = false;
    public var onGroundPrev:Bool = false;
   
    public var inWater:Bool = false;
    public var inWaterPrev:Bool = false;
    public var usesStairs:Bool = false;
    public var collideOneWay:Bool = true;

    public var totalBounceCount:Int = 0;
    public var bounceCount:Int = 0;
    public var canBounce(get, null):Bool;

    public var debug:Int = 0;    

    public var skip:Bool = false;

    public var down(get, null):Bool;
    public var downPrev(get, null):Bool;
    public var up(get, null):Bool;
    public var upPrev(get, null):Bool;
    public var left(get, null):Bool;
    public var leftPrev(get, null):Bool;
    public var right(get, null):Bool;
    public var rightPrev(get, null):Bool;

    // public var sweep:AABB2 = new glaze.geom.AABB2();

    public function new(material:Material = null,mass:Float = 1) {
        this.material = material==null ? new Material() : material;
        setMass(mass);
    }

    public function update(dt:Float,globalForces:Vector2,globalDamping:Float) {
        this.dt = dt;
        onGroundPrev = onGround;
        onGround = false;
        inWaterPrev = inWater;
        inWater = false;

        if (skip||isSleeping) return;

        motion = (SLEEP_BIAS * motion) + ((1 - SLEEP_BIAS) * velocity.lengthSqrd());
        motion = Math.min(motion,10*SLEEP_EPSILON);
        canSleep = motion<SLEEP_EPSILON;

        //Add global forces to local ones
        forces.plusMultEquals(globalForces,globalForceFactor);
        velocity.plusEquals(forces);
        velocity.multEquals(globalDamping*damping);

        //Which velocity limiting type?
        // if (!isBullet) {
            if (maxScalarVelocity>0) {
                velocity.clampScalar(maxScalarVelocity);
            } else {
                velocity.clampVector(maxVelocity);
            }            
        // }

        originalVelocity.copy(velocity);

        predictedPosition.copy(position);
        predictedPosition.plusMultEquals(velocity,dt);
        previousPosition.copy(position);

        delta.copy(predictedPosition);                  
        delta.minusEquals(position);

        prevContactNormal.copy(contactNormal);
        contactNormal.setTo(0,0);

        forces.setTo(0,0);
        damping = 1;

        stepContactCount = 0;

        toi = Math.POSITIVE_INFINITY;
    }

    public function respondStaticCollision(contact:Contact):Bool {
        if (skip) return false;
        var seperation = Math.max(contact.distance,0);
        var penetration = Math.min(contact.distance,0);
        
        //positionCorrection.x -= contact.normal.x * (penetration/dt);
        //positionCorrection.y -= contact.normal.y * (penetration/dt);
        positionCorrection.minusMultEquals(contact.normal,penetration/dt);

        var nv = velocity.dot(contact.normal) + (seperation/dt);

        if (nv<0) {
            stepContactCount++;

            //Cancel normal vel
            // velocity.x -= contact.normal.x * nv;
            // velocity.y -= contact.normal.y * nv;
            velocity.minusMultEquals(contact.normal,nv);

            //Item doesnt bounce? Surface is updwards?
            if (!canBounce && contact.normal.y < 0) {
                onGround = true;
                //Apply Friction here?
                // var tangent:Vector2 = contact.normal.rightHandNormal();
                // var tv:Float = velocity.dot(tangent) * material.friction;
                // velocity.x -= tangent.x * tv;
                // velocity.y -= tangent.y * tv;
            }

            //store contact normal for later reflection
            contactNormal.copy(contact.normal);

            return true;
        } 
        return false;
    }

    public function t(msg:String) {
         if (debug>0) {
            trace(msg);
            debug--;
        }
    }

    public function respondBulletCollision(contact:Contact):Bool {
        //Record the closest time
        if (contact.time<=toi) {
            toi = contact.time;
            positionCorrection.copy(contact.sweepPosition);
            contactNormal.copy(contact.normal);
            return true;
        }
        return false;
    }

    public function updatePosition() {
        if (skip||isSleeping) return;
        //Its a bullet and it hit something?
        if (isBullet) {
            if (toi<Math.POSITIVE_INFINITY) {
                position.copy(positionCorrection);
                originalVelocity.reflectEquals(contactNormal);
                //Fixme
                originalVelocity.multEquals(material.elasticity);
                velocity.copy(originalVelocity);
            } else {
                position.copy(predictedPosition);                
            }
            return;
        }

        //This body isnt a bullet so...

        //apply Friction here
        if (stepContactCount>0 && !canBounce && contactNormal.y < 0) {
        // if (stepContactCount>0 && contactNormal.y < 0) {
            //onGround = true;
            // var tangent:Vector2 = contactNormal.rightHandNormal();
            tangent.copy(contactNormal);
            tangent.rightHandNormalEquals();
            var tv:Float = originalVelocity.dot(tangent) * material.friction;
            velocity.x -= tangent.x * tv;
            velocity.y -= tangent.y * tv;
        }

        positionCorrection.plusEquals(velocity);
        positionCorrection.multEquals(dt);
        position.plusEquals(positionCorrection);
        positionCorrection.setTo(0,0);

        //Anything hit? Any bounces left?
        if (stepContactCount>0 && canBounce) {
            //Reflect it...
            originalVelocity.reflectEquals(contactNormal);
            //Remove velocity
            originalVelocity.multEquals(material.elasticity);
            //Set the new velocity
            velocity.copy(originalVelocity);
            bounceCount++;
        }

    }

    inline public function addForce(f:Vector2) {
        forces.plusMultEquals(f,invMass);
        wake();
    }

    inline public function addMasslessForce(f:Vector2) {
        forces.plusEquals(f);
        wake();
    }

    inline public function addProportionalForce(f:Vector2) {
        forces.plusMultEquals(f,mass);
        wake();
    }

    public function setMass(mass) {
        this.mass = mass;
        this.invMass = 1/mass;
    }

    public function setMassFromVolumeMaterial(volume:Float) {
        setMass(material.density*volume*MASS_SCALE); 
    }

    public function setStaticPosition(x:Float,y:Float) {
        position.setTo(x,y);
        positionCorrection.setTo(0,0);
        predictedPosition.setTo(0,0);
        forces.setTo(0,0);
        accumulatedForces.setTo(0,0);
        velocity.setTo(0,0);
        originalVelocity.setTo(0,0);
        delta.setTo(0,0);
        wake();
    }

    public function setBounces(count:Int) {
        totalBounceCount = count;
        bounceCount = 0; 
    }

    inline function get_canBounce():Bool {
        return totalBounceCount!=0 && bounceCount<totalBounceCount;
    }

    inline function wake() {
        canSleep = false;
        motion = WAKE_MOTION;
        bounceCount = 0;
    }

    inline function get_down():Bool     { return contactNormal.y<0; };
    inline function get_downPrev():Bool { return prevContactNormal.y<0; };
    inline function get_up():Bool       { return contactNormal.y>0; };
    inline function get_upPrev():Bool   { return prevContactNormal.y>0; };
    inline function get_left():Bool     { return contactNormal.x<0; };
    inline function get_leftPrev():Bool { return prevContactNormal.x<0; };
    inline function get_right():Bool    { return contactNormal.x>0; };
    inline function get_rightPrev():Bool{ return prevContactNormal.x>0; };


    public static function Create(material:Material,mass:Float,bounces:Int,globalForceFactor:Float,maxScalarVelocity:Float):Body {
        var body = new Body(material);
        body.setMass(mass);
        body.setBounces(bounces);     
        body.globalForceFactor = globalForceFactor;
        body.maxScalarVelocity = maxScalarVelocity; 
        return body;
    }

}