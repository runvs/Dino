package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

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