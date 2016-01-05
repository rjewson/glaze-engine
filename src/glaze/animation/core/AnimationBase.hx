package glaze.animation.core;

class AnimationBase
{
	public var parent:AnimationController;
	public var name:String;
	public var curIndex(default, set):Int = 0;
	
	private function set_curIndex(Value:Int):Int
	{
		curIndex = Value;
		
		if (parent != null && parent._curAnim == this)
		{
			parent.frameIndex = Value;
		}
		
		return Value;
	}
	
	public function new(Parent:AnimationController, Name:String)
	{
		parent = Parent;
		name = Name;
	}
	
	public function destroy():Void
	{
		parent = null;
		name = null;
	}
	
	public function update(elapsed:Float):Void {}
	
	public function clone(Parent:AnimationController):AnimationBase
	{
		return null;
	}
}