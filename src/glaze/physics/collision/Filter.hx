
package glaze.physics.collision;

class Filter 
{

    public var categoryBits:Int = 0x0001;
    public var maskBits:Int = 0xFFFF;
    public var groupIndex:Int = 0;

    public function new() {   
    }

    public static function CHECK(filterA:Filter,filterB:Filter):Bool {
        if (filterA==null||filterB==null)
            return true;
        else if ((filterA.groupIndex > 0 && filterB.groupIndex > 0 && filterA.groupIndex == filterB.groupIndex)) {
            return false; 
        } else {
            if ((filterA.maskBits & filterB.categoryBits) == 0) return false;
            if ((filterA.categoryBits & filterB.maskBits) == 0) return false;         
        }        
        return true;
    }


}