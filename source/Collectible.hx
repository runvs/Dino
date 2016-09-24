package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Collectible extends ConditionalObject
{
	
	public var name : String;
	private var _storyManagerID : String;
	
	private var _icon : FlxSprite;
	
	private var _started : Bool = false;
	
	public function new(n:String) 
	{
		super();
		name = n;
		_storyManagerID = "has_" + name;
		
		LoadSprites();
		
		
	}
	
	public function collectMe()
	{
		if (alive)
		{
			this.alive = false;
			StoryManager.setBool(_storyManagerID, true);
		}
	}
	
	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		
		if (!_started)
		{
			_started = true;
			y += 3
			FlxTween.tween(this, { y:y - 8 }, 1.75, { type:FlxTween.PINGPONG, ease : FlxEase.sineInOut } );
		}
		
	}
	
	
	function LoadSprites():Void 
	{
		if (name == "leaf")
		{
			trace("add leaf");
			this.loadGraphic(AssetPaths.item_leaf__png, false, 16, 16);
		}
		else if (name == "stone")
		{
			trace("add stone");
			this.loadGraphic(AssetPaths.item_stone__png, false, 16, 16);
		}
		else if (name == "branch")
		{
			trace("add branch");
			this.loadGraphic(AssetPaths.item_branch__png, false, 16, 16);
		}
		else
		{
			this.makeGraphic(16, 16, FlxColor.BLUE);
			this.alpha = 0.3;
		}
		cameras = [GP.CameraMain];
	}
	
	
	
}