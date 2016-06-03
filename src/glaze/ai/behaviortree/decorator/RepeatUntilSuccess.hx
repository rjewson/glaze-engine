package glaze.ai.behaviortree.decorator;

import glaze.ai.behaviortree.Decorator;

class RepeatUntilSuccess extends Decorator
{

	public function new() {
		super();
	}

	override private function update(context:BehaviorContext):BehaviorStatus {
		if (child.tick(context)==Success)
			return Success;
		return Running;
	}

}
