package glaze.ai.behaviortree;

import glaze.ai.behaviortree.Composite;
import glaze.ai.behaviortree.Parallel;
import glaze.ai.behaviortree.Behavior;
import haxe.Json;

/**
 * Behavior tree generator
 */

typedef BehaviourDef = {
  var type:String;
  var params:Array<Dynamic>;
  var children:Array<BehaviourDef>;
}

class BehaviorTree
{

	public static function fromJSON(jsonData:String):Behavior {
		var data:BehaviourDef = Json.parse(jsonData);
		return behaviourFromDynamic(data);
	}

	public static function compositeFromDynamic(composite:Composite, data:BehaviourDef) {
		if (data.children==null)
			return;
		for (child in data.children) {
			composite.addChild(behaviourFromDynamic(child));
		}	
	}

	public static function behaviourFromDynamic(data:BehaviourDef):Behavior {
		
		switch (data.type) {
			case "Sequence":
				var sequence = new Sequence();
				compositeFromDynamic(sequence,data);
				return sequence;
			case "Monitor":
				var monitor = new Monitor();
				compositeFromDynamic(monitor,data);
				return monitor;
			default:
				// js.Lib.debug();

				var actionClass = Type.resolveClass(data.type);
				if (actionClass!=null) {
					if (data.params==null)
						data.params = [];
					var action = Type.createInstance(actionClass,data.params);
					return action;
				} else {
					trace("Couldnt find:"+actionClass);
				}
		}

		return null;
	}

	// /**
	//  * Generate a behavior tree from an xml string
	//  * @param xmlData the xml data string to parse
	//  */
	// public static function fromXml(xmlData:String):Selector
	// {
	// 	var xml = Xml.parse(xmlData);
	// 	var selector = new Selector();
	// 	if (xml != null)
	// 	{
	// 		xml = xml.firstElement();
	// 		compositeFromXml(xml, selector);
	// 	}
	// 	return selector;
	// }

	// private static function compositeFromXml(xml:Xml, composite:Composite)
	// {
	// 	for (element in xml.elements())
	// 	{
	// 		composite.addChild(behaviorFromXml(element));
	// 	}
	// }

	// private static function behaviorFromXml(xml:Xml):Behavior
	// {
	// 	switch (xml.nodeName)
	// 	{
	// 		case "action":
	// 			return null;//new Action(xml.firstChild().nodeValue);
	// 		case "sequence":
	// 			var sequence = new Sequence();
	// 			compositeFromXml(xml, sequence);
	// 			return sequence;
	// 		case "parallel":
	// 			var success = xml.exists("success") ? policyFromString(xml.get("success")) : RequireOne;
	// 			var failure = xml.exists("failure") ? policyFromString(xml.get("failure")) : RequireOne;
	// 			var parallel = new Parallel(success, failure);
	// 			compositeFromXml(xml, parallel);
	// 			return parallel;
	// 		case "repeat":
	// 			var behavior = behaviorFromXml(xml.firstElement());
	// 			var count = xml.exists("count") ? Std.parseInt(xml.get("count")) : 1;
	// 			var repeat = new Repeat(behavior, count);
	// 			return repeat;
	// 		case "active":
	// 			var active = new ActiveSelector();
	// 			compositeFromXml(xml, active);
	// 			return active;
	// 		case "selector":
	// 			var selector = new Selector();
	// 			compositeFromXml(xml, selector);
	// 			return selector;
	// 		default:
	// 			throw "Unrecognized behavior type : " + xml.nodeName;
	// 	}
	// }

	// private static function policyFromString(policy:String):Policy
	// {
	// 	switch (policy)
	// 	{
	// 		case "one":
	// 			return RequireOne;
	// 		case "all":
	// 			return RequireAll;
	// 		default:
	// 			throw "Invalid policy, expected `one` or `all`.";
	// 	}
	// }

}
