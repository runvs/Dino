package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

/**
 * ...
 * @author 
 */
class Collectible extends ConditionalObject
{
	public var _storyManagerID (default, null) : String;
	
	public var _started : Bool = false;
	
	private var _glow : GlowOverlay;
	
	private var _teleport : Teleport = null;
	
	
	public function new(n:String) 
	{
		super();
		name = n;
		_storyManagerID = "has_" + name;
		
		LoadSprites(this, name);
		
		_glow = new GlowOverlay(x, y, GP.CameraMain, Std.int(32), 0.7, 1.5);
		_glow.alpha = 0.2;
		_glow.blend = BlendMode.LIGHTEN;
		
	}
	
	
	public function setTeleport(level:String, entryID: Int)
	{
		_teleport = new Teleport(0,0);
		_teleport.targetLevel = level;
		_teleport.entryID = entryID;
	}
	
	public function collectMe(stage:BasicState)
	{
		if (alive)
		{
			this.alive = false;
			trace("collecting "+_storyManagerID );
			StoryManager.setBool(_storyManagerID, true);
			
			if (_teleport != null)
			{
				_teleport.perform(stage);
			}
		}
	}
	
	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		
		_glow.setPosition(( x + 8) ,(y + 8) );
		_glow.update(elapsed);
		
		if (!_started)
		{
			_started = true;
			y += 3;
			FlxTween.tween(this, { y:y - 8 }, 1.75, { type:FlxTween.PINGPONG, ease : FlxEase.sineInOut } );
		}
		
	}
	
	override public function draw():Void 
	{
		//trace("draw");

		_glow.draw(); 
		super.draw();

		
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
	
	
	public function resetCamera()
	{
		_glow.cameras = [GP.CameraMain];
	}
	
	
}