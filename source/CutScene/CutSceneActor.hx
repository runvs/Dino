package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class CutSceneActor extends FlxSprite
{

	public var name (default, null) : String ;
	public var overlay : FlxSprite;
	
	public function new(n: String) 
	{
		name = n;
		super();
		
		LoadActor();
		
		overlay = new FlxSprite();
		overlay.makeGraphic(120, 90, FlxColor.RED);
		overlay.alpha = 0.5;
		overlay.cameras = [GP.CameraOverlay];
	}
	
	function LoadActor() 
	{
		switch (name)
		{
			case "dino":
				//trace("load dino");
				this.loadGraphic(AssetPaths.dino__png, true, 24, 18);
				this.animation.add("idle", [5,5,5,4,5,5,5,5,5,6,7,8,9], 4);
				this.animation.add("walk", [0, 1, 2, 3], 4);
				this.animation.add("jumpUp", [15, 16, 17], 4, false);
				this.animation.add("jumpDown", [18, 19, 20], 4, false);
				this.animation.play("idle");
				setFacingFlip(FlxObject.LEFT, false, false);
				setFacingFlip(FlxObject.RIGHT, true, false);
				
			case "dinobag":
				this.loadGraphic(AssetPaths.dino_bag__png, true, 24, 18);
				this.animation.add("idle", [5, 5, 5, 4, 5, 5, 5, 5, 5, 6, 7, 8, 9], 4);
				this.animation.add("idle2", [45, 46, 47,48,49,50], 3);
				this.animation.add("walk", [0, 1, 2, 3], 4);
				this.animation.add("sleep", [10, 10, 11, 11, 12 ,12, 13,  13], 4, true);
				this.animation.add("wakeup", [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 33, 34,35,36, 37], 5, false);
				this.animation.add("dance", [39,40,41,42,43,44], 5, true);
				this.animation.play("idle");
				setFacingFlip(FlxObject.LEFT, false, false);
				setFacingFlip(FlxObject.RIGHT, true, false);
			case "overlay":
				//trace("load overlay");
				this.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
				this.alpha = 0;
				this.scrollFactor.set();
				this.color.setRGB(0, 0, 0);
				this.cameras = [GP.CameraOverlay];
			case "invis":
				//trace ("load invis");
				this.makeGraphic(1, 1, FlxColor.TRANSPARENT);
				
			default:
				throw "Actor " + name + " not known";
				
		}
		this.cameras = [GP.CameraMain];
	}
	
	public override function update (elapsed : Float ) : Void 
	{
		super.update(elapsed);
		overlay.setPosition(x * GP.CameraMain.zoom, y * GP.CameraMain.zoom);
		if(velocity.x > 0)
		{
			facing = FlxObject.RIGHT;
		}
		else if(velocity.x < 0)
		{
			facing = FlxObject.LEFT;
		}

	}
}