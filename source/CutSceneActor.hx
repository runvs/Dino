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
		//doverlay.makeGraphic(120, 90, FlxColor.TRANSPARENT);
		overlay.makeGraphic(120, 90, FlxColor.RED);
		overlay.alpha = 0.5;
		overlay.cameras = [GP.CameraOverlay];
	}
	
	function LoadActor() 
	{
		switch (name)
		{
			case "dino":
				trace("load dino");
				this.loadGraphic(AssetPaths.dino__png, true, 24, 18);
				this.animation.add("idle", [5,5,5,4,5,5,5,5,5,6,7,8,9], 4);
				this.animation.add("walk", [0, 1, 2, 3], 4);
				this.animation.add("jumpUp", [15, 16, 17], 4, false);
				this.animation.add("jumpDown", [18, 19, 20], 4, false);
				this.animation.play("idle");
				setFacingFlip(FlxObject.LEFT, false, false);
				setFacingFlip(FlxObject.RIGHT, true, false);

			case "overlay":
				trace("load overlay");
				this.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
				this.scrollFactor.set();
				this.color.setRGB(0, 0, 0);
			case "invis":
				trace ("load invis");
				this.makeGraphic(1, 1, FlxColor.TRANSPARENT);
				
			default:
				throw "Actor " + name + "not known";
				
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