
package glaze.physics.collision;

class Filter 
{

    //Two positive and equal group indexs always collide
    //Two negative and equal group indexs never collide
    //Two zero group indexs are passed through
    public var groupIndex:Int = 0;

    //What category this filter is in
    public var categoryBits:Int = 0x0001;
    //What other categories it can collide with
    public var maskBits:Int = 0xFFFF;

    //e.g.
    //player.filter.categoryBits = 0x0002
    //player.filter.maskBits     = 0x0004
    //
    //enemy.filter.categoryBits  = 0x0004
    //enemy.filter.maskBits      = 0x0002
    //
    //Here, players an enemies will collide
    //overever players wont collide with player or monsters with mosters


    public function new() {   
    }

    public static function CHECK(filterA:Filter,filterB:Filter):Bool {
        if (filterA==null||filterB==null)
            return true;
        
        // if ((filterA.groupIndex > 0 && filterB.groupIndex > 0 && filterA.groupIndex == filterB.groupIndex)) {
        //     return false; 
        // } 

        if (filterA.groupIndex==filterB.groupIndex && filterA.groupIndex!=0)
            return filterA.groupIndex > 0;

        return ((filterA.maskBits & filterB.categoryBits) != 0 && (filterA.categoryBits & filterB.maskBits) != 0);

        // else {
        //     if ((filterA.maskBits & filterB.categoryBits) == 0) return false;
        //     if ((filterA.categoryBits & filterB.maskBits) == 0) return false;         
        // }        
        // return true;
    }


}