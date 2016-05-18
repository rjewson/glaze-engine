package glaze.debug;

import glaze.engine.core.GameEngine;
import glaze.particle.IParticleEngine;

class DebugEngine {

	public static var gameEngine:GameEngine;
	public static var particleEngine:IParticleEngine;

	public static function GetAllEntities():Dynamic {
		var result = "<table width='100%'>";
		result += "<col style='width:10%'>";
		result += "<col style='width:10%'>";
		result += "<col style='width:60%'>";
		result += "<col style='width:20%'>";
		for (entity in gameEngine.engine.entities) {
			var ehtml = "<tr>";

			ehtml += "<td>"+entity.id+"</td>";
			ehtml += "<td>"+entity.referenceCount+"</td>";
			ehtml += "<td>"+entity.name+"</td>";
			ehtml += "<td><button onclick='glaze.debug.DebugEngine.DumpEntity("+entity.id+");'>Inspect</button></td>";
			
			ehtml += "</tr>";
			result += ehtml;
		}
		result += "</table>";
		return result;
	}

	public static function GetAllSystems():Dynamic {
		var result = "<table width='100%'>";
		result += "<col style='width:10%'>";
		result += "<col style='width:70%'>";
		result += "<col style='width:20%'>";
		for (system in gameEngine.engine.systems) {

			var name = Type.getClassName(Type.getClass(system));

			var ehtml = "<tr>";

			ehtml += "<td>"+name.split('.').pop()+"</td>";
			ehtml += "<td></td>";
			ehtml += "<td><button onclick='glaze.debug.DebugEngine.DumpSystem(\""+name+"\");'>Inspect</button></td>";
			
			ehtml += "</tr>";
			result += ehtml;
		}
		result += "</table>";
		return result;
	}

	@:expose
	public static function DumpEntity(id:Int) {
		for (entity in gameEngine.engine.entities) {
			if (entity.id == id) {
				untyped window.console.dir(entity);
				return;
			}
		}
	}

	@:expose
	public static function DumpSystem(className:String) {
		js.Lib.debug();
		untyped window.console.dir(gameEngine.engine.systemMap.get(className));
	}

	public static function DrawParticle(x:Float,y:Float,size:Int,r:Int,g:Int,b:Int) {
		particleEngine.EmitParticle(x,y,0,0,0,0,17,1,false,true,null,size,255,r,g,b);
	}

}