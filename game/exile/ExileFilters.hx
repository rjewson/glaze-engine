package exile;

class ExileFilters {

	//Categories
	public static inline var PLAYER_CAT:Int = 					0x1 << 2;
	public static inline var PROJECTILE_CAT:Int =				0x1 << 3;
	public static inline var PROJECTILE_COLLIDABLE_CAT:Int =	0x1 << 4;
	public static inline var SOLID_CAT:Int = 					0x1 << 5;
	public static inline var HOLDABLE_CAT:Int = 				0x1 << 6;
	public static inline var ph1_CAT:Int = 						0x1 << 7;
	public static inline var ph2_CAT:Int = 						0x1 << 8;
	public static inline var ph3_CAT:Int = 						0x1 << 9;
	public static inline var ph4_CAT:Int = 						0x1 << 10;
	public static inline var ph5_CAT:Int = 						0x1 << 11;

	//Groups
	public static inline var PLAYER_GROUP:Int = -1;
	public static inline var ENEMY_GROUP:Int =  -2;
	public static inline var TURRET_GROUP:Int =  -3;

	public static inline var SOLID_OBJECT_GROUP:Int = 1;  //e.g. Doors

}