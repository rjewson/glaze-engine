package glaze.animation.core;

import glaze.render.frame.Frame;
import glaze.render.frame.FrameList;

class AnimationController
{
	/**
	 * Property access for currently playing FlxAnimation (warning: can be null).
	 */
	public var curAnim(get, set):Animation;
	
	/**
	 * Tell the sprite to change to a specific frame of the _curAnim.
	 */
	public var frameIndex(default, set):Int = -1;
	
	/**
	 * Tell the sprite to change to a frame with specific name.
	 * Useful for sprites with loaded TexturePacker atlas.
	 */
	public var frameName(get, set):String;
	
	/**
	 * Gets or sets the currently playing animation (warning: can be null).
	 */
	public var name(get, set):String;
	
	/**
	 * Pause & resume curAnim.
	 */
	public var paused(get, set):Bool;
	
	/**
	 * Returns whether an animation has finished playing.
	 */
	public var finished(get, set):Bool;
	
	/**
	 * The total number of frames in this image.
	 * WARNING: assumes each row in the sprite sheet is full!
	 */
	public var frames(get, null):Int;
	
	/**
	 * If assigned, will be called each time the current frame changes.
	 * A function that has 3 parameters: a string name, a frame number, and a frame index.
	 */
	public var callback:String->Int->Int->Void;
	
	/**
	 * If assigned, will be called each time the current animation finishes.
	 * A function that has 1 parameter: a string name - animation name.
	 */
	public var finishCallback:String->Void;
	
	/**
	 * Internal, reference to owner sprite.
	 */
	private var _frames:FrameList;
	
	/**
	 * Internal, currently playing animation.
	 */
	@:allow(glaze.animation.core)
	private var _curAnim:Animation;
	
	/**
	 * Internal, stores all the animation that were added to this sprite.
	 */
	@:allow(flixel.FlxSprite)
	private var _animations(default, null):Map<String, Animation>;
	
	
	public function new(Frames:FrameList)
	{
		_frames = Frames;
		_animations = new Map<String, Animation>();
	}
	
	public function update(elapsed:Float):Void
	{
		if (_curAnim != null)
		{
			_curAnim.update(elapsed);
		}
	}
	
	/**
	 * Adds a new animation to the sprite.
	 * @param	Name		What this animation should be called (e.g. "run").
	 * @param	Frames		An array of numbers indicating what frames to play in what order (e.g. 1, 2, 3).
	 * @param	FrameRate	The speed in frames per second that the animation should play at (e.g. 40 fps).
	 * @param	Looped		Whether or not the animation is looped or just plays once.
	 * @param	FlipX		Whether the frames should be horizontally flipped
	 * @param	FlipY		Whether the frames should be vertically flipped
	 */
	public function add(Name:String, Frames:Array<Int>, FrameRate:Int = 30, Looped:Bool = true, FlipX:Bool = false, FlipY:Bool = false):Void
	{
		// Check _animations frames
		var framesToAdd:Array<Int> = Frames;
		var numFrames:Int = framesToAdd.length - 1;
		var i:Int = numFrames;
		while (i >= 0)
		{
			if (framesToAdd[i] >= frames)
			{
				// Splicing original Frames array could lead to unexpected results
				// So we are cloning it (only once) and will use its copy
				if (framesToAdd == Frames)
				{
					framesToAdd = Frames.copy();
				}
				
				framesToAdd.splice(i, 1);
			}
			i--;
		}
		
		if (framesToAdd.length > 0)
		{
			var anim = new Animation(this, Name, framesToAdd, FrameRate, Looped, FlipX, FlipY);
			_animations.set(Name, anim);
		}
	}
	
	/**
	 * Removes (and destroys) an animation.
	 * 
	 * @param	Name	The name of animation to remove.
	 */
	public function remove(Name:String):Void
	{
		var anim:Animation = _animations.get(Name);
		if (anim != null)
		{
			_animations.remove(Name);
		}
	}
	

	
	/**
	 * Plays an existing animation (e.g. "run").
	 * If you call an animation that is already playing, it will be ignored.
	 * 
	 * @param	AnimName		The string name of the animation you want to play.
	 * @param	Force			Whether to force the animation to restart.
	 * @param	Reversed		Whether to play animation backwards or not.
	 * @param	Frame			The frame number in the animation you want to start from (0 by default).
	 *                     		If you pass negative value then it will start from random frame
	 */
	public function play(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (AnimName == null)
		{
			if (_curAnim != null)
			{
				_curAnim.stop();
			}
			_curAnim = null;
		}
		
		if (AnimName == null || _animations.get(AnimName) == null)
		{
			return;
		}
		
		var oldFlipX:Bool = false;
		var oldFlipY:Bool = false;
		
		if (_curAnim != null && AnimName != _curAnim.name)
		{
			oldFlipX = _curAnim.flipX;
			oldFlipY = _curAnim.flipY;
			_curAnim.stop();
		}
		_curAnim = _animations.get(AnimName);
		_curAnim.play(Force, Reversed, Frame);
		
		if (oldFlipX != _curAnim.flipX || oldFlipY != _curAnim.flipY)
		{
			//_sprite.dirty = true;
		}
	}
	
	/**
	 * Stops current animation and resets its frame index to zero.
	 */
	public inline function reset():Void
	{
		if (_curAnim != null)
		{
			_curAnim.reset();
		}
	}
	
	/**
	 * Stops current animation and sets its frame to the last one.
	 */
	public function finish():Void
	{
		if (_curAnim != null)
		{
			_curAnim.finish();
		}
	}
	
	/**
	 * Just stops current animation.
	 */
	public function stop():Void
	{
		if (_curAnim != null)
		{
			_curAnim.stop();
		}
	}
	
	/**
	 * Pauses the current animation.
	 */
	public inline function pause():Void
	{
		if (_curAnim != null)
		{
			_curAnim.pause();
		}
	}
	
	/**
	 * Resumes the current animation if it exists.
	 */
	public inline function resume():Void
	{
		if (_curAnim != null)
		{
			_curAnim.resume();
		}
	}
	
	/**
	 * Reverses current animation if it exists.
	 */
	public inline function reverse():Void
	{
		if (_curAnim != null)
		{
			_curAnim.reverse();
		}
	}
	
	/**
  	 * Gets the FlxAnimation object with the specified name.
	 */
	public inline function getByName(Name:String):Animation
	{
		return _animations.get(Name); 
	}
	
	/**
	 * Changes to a random animation frame.
	 * Useful for instantiating particles or other weird things.
	 */
	public function randomFrame():Void
	{
		if (_curAnim != null)
		{
			_curAnim.stop();
			_curAnim = null;
		}
		frameIndex = glaze.util.Random.RandomInteger(0, frames - 1);
	}
	
	private inline function fireCallback():Void
	{
		if (callback != null)
		{
			var name:String = (_curAnim != null) ? (_curAnim.name) : null;
			var number:Int = (_curAnim != null) ? (_curAnim.curFrame) : frameIndex;
			callback(name, number, frameIndex);
		}
	}
	
	@:allow(glaze.animation.core)
	private inline function fireFinishCallback(name:String = null):Void
	{
		if (finishCallback != null)
		{
			finishCallback(name);
		}
	}
	

	
	private function set_frameIndex(Frame:Int):Int
	{
		if (_frames != null)
		{
			Frame = Frame % frames;
			//_sprite.frame = _frames.frames[Frame];
			frameIndex = Frame;
			fireCallback();
		}
		
		return frameIndex;
	}
	
	private inline function get_frameName():String
	{
		return "todo";//_sprite.frame.name;
	}
	
	private function set_frameName(Value:String):String
	{
		if (_frames != null && _frames.framesHash.exists(Value))
		{
			if (_curAnim != null)
			{
				_curAnim.stop();
				_curAnim = null;
			}
			
			var frame = _frames.framesHash.get(Value);
			if (frame != null)
			{
				frameIndex = getFrameIndex(frame);
			}
		}
		
		return Value;
	}
	
	private function get_name():String
	{
		var animName:String = null;
		if (_curAnim != null)
		{
			animName = _curAnim.name;
		}
		return animName;
	}
	
	private function set_name(AnimName:String):String
	{
		play(AnimName);
		return AnimName;
	}
	
	private inline function get_curAnim():Animation
	{
		return _curAnim;
	}
	
	private inline function set_curAnim(Anim:Animation):Animation
	{
		if (Anim != _curAnim)
		{
			if (_curAnim != null) 
			{
				_curAnim.stop();
			}
			
			if (Anim != null)
			{
				Anim.play();
			}
		}
		return _curAnim = Anim;
	}
	
	private inline function get_paused():Bool
	{
		var paused:Bool = false;
		if (_curAnim != null)
		{
			paused = _curAnim.paused;
		}
		return paused;
	}
	
	private inline function set_paused(Value:Bool):Bool
	{
		if (_curAnim != null)
		{
			if (Value) 
			{ 
				_curAnim.pause();
			} 
			else
			{
				_curAnim.resume();
			}
		}
		return Value;
	}
	
	private function get_finished():Bool
	{
		var finished:Bool = true;
		if (_curAnim != null)
		{
			finished = _curAnim.finished;
		}
		return finished;
	}
	
	private inline function set_finished(Value:Bool):Bool
	{
		if (Value == true && _curAnim != null)
		{
			_curAnim.finish();
		}
		return Value;
	}
	
	private inline function get_frames():Int
	{
		return _frames.numFrames;
	}
	
	/**
	 * Helper function used for finding index of FlxFrame in _framesData's frames array
	 * @param	Frame	FlxFrame to find
	 * @return	position of specified FlxFrame object.
	 */
	public inline function getFrameIndex(Frame:Frame):Int
	{
		return _frames.frames.indexOf(Frame);
	}

	public function getFrame():Frame {
		return _frames.frames[frameIndex];
	}
}