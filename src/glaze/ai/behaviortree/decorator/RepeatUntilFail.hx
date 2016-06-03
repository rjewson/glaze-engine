package glaze.ai.behaviortree.decorator;

import glaze.ai.behaviortree.Decorator;

class RepeatUntilFail extends Decorator
{

	public function new() {
		super();
	}

	override private function update(context:BehaviorContext):BehaviorStatus {
		if (child.tick(context)==Failure)
			return Failure;
		return Running;
	}

}
