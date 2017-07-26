package;

import dat.Data;

class Test {

    public static function load() {
        dat.Data.load(CompileTime.readJsonFile("test.cdb"));
        dat.Data.doors.all;
        // var x = dat.Data.entities.get(HallDoor).
        // trace(dat.Data.things.get(r));
        // trace(dat.Data.items.get(sword).alt.fx);
		// trace(dat.Data.items.get(sword).alt.test);
        // trace(dat.Data.Things);
        // var t = dat.Data.things.resolve("r");
    }

}