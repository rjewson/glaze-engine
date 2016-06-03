package glaze.ai.behaviortree.decorator;

import glaze.ai.behaviortree.Decorator;

class Invert extends Decorator
{

	public function new() {
		super();
	}

	override private function update(context:BehaviorContext):BehaviorStatus {
		switch (child.tick(context))
		{
			case Running:
				return Running;
			case Failure:
				return Success;
			default:
				return Success;
		}
		return Failure;

	}

}
/*

{
	task:seq
	
}


*/