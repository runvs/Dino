package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class SpeechBubbleArea extends ConditionalObject
{	
	public var _name (default, null) : String = "";
	
	public function new(n : String, X:Float=0, Y:Float=0, W : Int = 1, H: Int = 1) 
	{
		super();
		_name = n;
		this.setPosition(X, Y);
		this.makeGraphic(W, H, FlxColor.YELLOW);
		this.alpha = 0.25;
		this.cameras = [GP.CameraMain];
	}
	
	
	override public function draw():Void 
	{
		super.draw();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	public function getSpeechBubble(p : PlayableCharacter) : SpeechBubble
	{
		if (checkConditions())
		{
			return new SpeechBubble(p, _name, -1);
		}
		return null;
	}
	
	public function resetCamera()
	{
		this.cameras = [GP.CameraMain];
	}
}