package glaze.ai.behaviortree;

import engine.ai.behaviors.Parallel;

/**
 * Behavior tree generator
 */
class BehaviorTree
{

	/**
	 * Generate a behavior tree from an xml string
	 * @param xmlData the xml data string to parse
	 */
	public static function fromXml(xmlData:String):Selector
	{
		var xml = Xml.parse(xmlData);
		var selector = new Selector();
		if (xml != null)
		{
			xml = xml.firstElement();
			compositeFromXml(xml, selector);
		}
		return selector;
	}

	private static function compositeFromXml(xml:Xml, composite:Composite)
	{
		for (element in xml.elements())
		{
			composite.addChild(behaviorFromXml(element));
		}
	}

	private static function behaviorFromXml(xml:Xml):Behavior
	{
		switch (xml.nodeName)
		{
			case "action":
				return null;//new Action(xml.firstChild().nodeValue);
			case "sequence":
				var sequence = new Sequence();
				compositeFromXml(xml, sequence);
				return sequence;
			case "parallel":
				var success = xml.exists("success") ? policyFromString(xml.get("success")) : RequireOne;
				var failure = xml.exists("failure") ? policyFromString(xml.get("failure")) : RequireOne;
				var parallel = new Parallel(success, failure);
				compositeFromXml(xml, parallel);
				return parallel;
			case "repeat":
				var behavior = behaviorFromXml(xml.firstElement());
				var count = xml.exists("count") ? Std.parseInt(xml.get("count")) : 1;
				var repeat = new Repeat(behavior, count);
				return repeat;
			case "active":
				var active = new ActiveSelector();
				compositeFromXml(xml, active);
				return active;
			case "selector":
				var selector = new Selector();
				compositeFromXml(xml, selector);
				return selector;
			default:
				throw "Unrecognized behavior type : " + xml.nodeName;
		}
	}

	private static function policyFromString(policy:String):Policy
	{
		switch (policy)
		{
			case "one":
				return RequireOne;
			case "all":
				return RequireAll;
			default:
				throw "Invalid policy, expected `one` or `all`.";
		}
	}

}
