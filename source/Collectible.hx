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
	public var _storyManagerID (default, null) : String;
	
	private var _icon : FlxSprite;
	
	public var _started : Bool = false;
	
	public function new(n:String) 
	{
		super();
		name = n;
		_storyManagerID = "has_" + name;
		
		LoadSprites(this, name);
		
		
	}
	
	public function collectMe()
	{
		if (alive)
		{
			this.alive = false;
			trace("collecting "+_storyManagerID );
			StoryManager.setBool(_storyManagerID, true);
		}
	}
	
	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		
		if (!_started)
		{
			_started = true;
			y += 3;
			FlxTween.tween(this, { y:y - 8 }, 1.75, { type:FlxTween.PINGPONG, ease : FlxEase.sineInOut } );
		}
		
	}
	
	public static function LoadSprites(spr : FlxSprite, name : String):Void 
	{
		if (name == "leaf")
		{
			spr.loadGraphic(AssetPaths.item_leaf__png, false, 16, 16, true);
		}
		else if (name == "stone")
		{
			spr.loadGraphic(AssetPaths.item_stone__png, false, 16, 16, true);
		}
		else if (name == "branch")
		{
			spr.loadGraphic(AssetPaths.item_branch__png, false, 16, 16, true);
		}
		else
		{
			spr.makeGraphic(16, 16, FlxColor.BLUE);
			spr.alpha = 0.5;
		}
		spr.cameras = [GP.CameraMain];
		spr.scale.set(0.5, 0.5);
	}
	
	
	
}