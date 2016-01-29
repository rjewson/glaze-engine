
package exile.util;

import glaze.core.DigitalInput;
import glaze.geom.Vector2;
import glaze.physics.Body;

class CharacterController 
{

    private var body:Body;
    private var input:DigitalInput;

    private var controlForce:Vector2 = new Vector2();

    private var jumpUnit:Vector2 = new Vector2();

    private static inline var WALK_FORCE:Float = 20;
    private static inline var AIR_CONTROL_FORCE:Float = 10;
    private static inline var JUMP_FORCE:Float = 1000;

    private static inline var MAX_AIR_HORIZONTAL_VELOCITY:Float = 500;

    private var jumping:Bool = false;

    public var isWalking:Bool = false;

    public var left:Int;
    public var right:Int;

    public function new(input:DigitalInput,body:Body) {
        this.input = input;
        this.body = body;
    }

    public function update() {

        controlForce.setTo(.0,.0);

        left = input.PressedDuration(65);   //a
        right = input.PressedDuration(68);  //d
        var up = input.JustPressed(87);         //w
        var upDuration = input.PressedDuration(87);         //w
        var down = input.PressedDuration(83);   //s

        //Just jumped?
        if (!jumping&&body.onGround&&up) {
            jumping = true;
            controlForce.y -= JUMP_FORCE/5;
        }

        if ((jumping&&input.Released(87))||(body.lastNormal.y>0)) {
            jumping = false;
        }

        //Just landed?
        if (body.onGround&&!body.onGroundPrev) {

        }

        if (body.inWater) {
            if (left>0)     controlForce.x -= WALK_FORCE;
            if (right>0)    controlForce.x += WALK_FORCE;
            if (up)         controlForce.y -= 400;
            if (down>0)       controlForce.y += WALK_FORCE;
        } else if (body.onGround) {
            if (left>0)     controlForce.x -= WALK_FORCE;
            if (right>0)    controlForce.x += WALK_FORCE;
            if (up)         controlForce.y -= JUMP_FORCE/5;
        } else {
            if (left>0)     controlForce.x -= AIR_CONTROL_FORCE;
            if (right>0)    controlForce.x += AIR_CONTROL_FORCE;
            var d = 10;
            if (jumping&&upDuration>1&&upDuration<d) controlForce.y -= 800/d;//(d-upDuration);
        }

        isWalking = body.onGround&&(left>0||right>0);

        body.addForce(controlForce);

    }

}