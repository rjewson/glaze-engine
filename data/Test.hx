package;

import dat.Data;

class Test {

    public static function load() {
        dat.Data.load(CompileTime.readJsonFile("test.cdb"));
        // var x = dat.Data.entities.get(HallDoor).
        // trace(dat.Data.things.get(r));
        // trace(dat.Data.items.get(sword).alt.fx);
		// trace(dat.Data.items.get(sword).alt.test);
        // trace(dat.Data.Things);
        js.Lib.debug();

        // var t = dat.Data.things.resolve("r");
        js.Lib.debug();
    }

}