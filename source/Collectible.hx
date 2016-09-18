package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Collectible extends ConditionalObject
{
	
	public var name : String;
	private var _storyManagerID : String;
	
	public function new(n:String) 
	{
		super();
		name = n;
		_storyManagerID = "has_" + name;
		this.makeGraphic(16, 16, FlxColor.BLUE);
		this.alpha = 0.3;
		cameras = [GP.CameraMain];
	}
	
	public function collectMe()
	{
		if (alive)
		{
			this.alive = false;
			StoryManager.setBool(_storyManagerID, true);
		}
	}
	
	
	
}