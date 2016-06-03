package glaze.ai.behaviortree.leaf;

import glaze.ai.behaviortree.Behavior;
import glaze.ai.behaviortree.BehaviorContext;
import glaze.ai.behaviortree.BehaviorStatus;


class CopyContextData extends Behavior
{

	public var source:String;
	public var target:String;

	public function new(source:String,target:String)
	{
		super();
		this.source = source;
		this.target = target;
	}

	override public function update(context:BehaviorContext):BehaviorStatus {

    	var sourceData:Dynamic = Reflect.field(context.data,source);

    	Reflect.setField(context.data,target,sourceData);

		return Success;
	}


}
