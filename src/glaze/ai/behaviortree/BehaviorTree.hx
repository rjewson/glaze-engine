package glaze.ai.behaviortree;

import glaze.ai.behaviortree.BehaviorTree.BehaviorDef;
import glaze.ai.behaviortree.Composite;
import glaze.ai.behaviortree.Behavior;
import haxe.Json;

/**
 * Behavior tree generator
 */


/*

Sequence handles behaviors in order and continues until one does not succeed
Selector handles behaviors in order chooses the first behavior that doesn't fail
Paralel STARTS all in parallel, success depeends on policy

*/

typedef TreeDef = {
	var name:String;
	var imports:Array<String>;
	var tree:BehaviorDef;
	var debug:Int;
}

typedef BehaviorDef = {
  var type:String;
  @:optional var description:String;
  @:optional var params:Array<Dynamic>;
  @:optional var children:Array<BehaviorDef>;
  @:optional var debug:Int;
}


class BehaviorTree
{
	public static var defaultBehaviours:Array<Class<Behavior>> = [
		glaze.ai.behaviortree.branch.Monitor,
		glaze.ai.behaviortree.branch.Parallel,
		glaze.ai.behaviortree.branch.Selector,
		glaze.ai.behaviortree.branch.Sequence,

		glaze.ai.behaviortree.decorator.Invert,
		glaze.ai.behaviortree.decorator.Repeat,
		glaze.ai.behaviortree.decorator.RepeatUntilSuccess,
		glaze.ai.behaviortree.decorator.RepeatUntilFail,

		glaze.ai.behaviortree.leaf.CopyContextData,
		glaze.ai.behaviortree.leaf.Failure,
		glaze.ai.behaviortree.leaf.FunctionExecutorAction,
		glaze.ai.behaviortree.leaf.Logger,
		glaze.ai.behaviortree.leaf.SetContextData,
		glaze.ai.behaviortree.leaf.Success
	];

	public static var extendedBehaviours:Array<Class<Behavior>> = [
		glaze.engine.actions.Delay,
		glaze.engine.actions.CanSee,
		glaze.engine.actions.FindTarget,
		glaze.engine.actions.WanderToTarget,
		glaze.engine.actions.SeekTarget,
		glaze.engine.actions.InRangeTarget
	];


	public static var behaviours:Map<String,Class<Behavior>> = new Map<String,Class<Behavior>>();
		
	public static var scripts:Map<String,TreeDef> = new Map<String,TreeDef>();

	// public static function testBT() {
	// 	var jsonString = CompileTime.readJsonFile("test.json");
	// 	var definition:TreeDef = Json.parse(jsonString);

	// 	initialize();

	// 	var treeInstance = behaviourFromDef(definition.tree,definition.debug);
	// 	trace(treeInstance);

	// }

	public static function initialize() {
		for (behaviour in defaultBehaviours) {
			registerBehaviour(behaviour);
		}

		for (behaviour in extendedBehaviours) {
			registerBehaviour(behaviour);
		}
	}

	public static function registerBehaviour(behaviour:Class<Behavior>) {
		var registeredName = Type.getClassName(behaviour).split('.').pop().toLowerCase();
		behaviours.set(registeredName,behaviour);
	}
 
	public static function registerScript(name:String,script:String) {
		scripts.set(name,Json.parse(script));
	}

	public static function createScript(name:String):Behavior {
		var script = scripts.get(name);
		if (script!=null) {
			return behaviourFromDef(script.tree,script.debug);
		}
		return null;
	}

	public static function behaviourFromDef(data:BehaviorDef,globalDebug:Int):Behavior {
		var classType:Class<Behavior> = behaviours.get(data.type.toLowerCase());
		var instance:Behavior = Type.createInstance(classType,data.params==null?[]:data.params);
		instance.description =  data.description;
		instance.debugLevel = data.debug!=null?data.debug:0;
		if (globalDebug>0 && globalDebug>instance.debugLevel)
			instance.debugLevel = globalDebug;


		if (data.children!=null) {
			for (child in data.children) {
				instance.addChild(behaviourFromDef(child,globalDebug));
			}			
		}

		return instance;
	}

}
