package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class CampFire extends FlxSprite
{

	var _glow : GlowOverlay ;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y+2);
		this.loadGraphic(AssetPaths.campfire__png, true, 16, 16);
		this.animation.add("idle", [1, 2, 1, 2, 1, 3, 2, 1, 2, 3, 4, 3, 2, 3, 2, 1], 6, true);
		this.animation.play("idle");
		this.cameras = [GP.CameraMain];
		
		_glow = new GlowOverlay((x+this.width/2) * 5, (y+this.height/2) * 5, GP.CameraOverlay, 240, 1, 0.5);
		_glow.alpha = 0.25;
		_glow.color = FlxColor.fromRGB(173, 132, 56);
	}
	
	public override function draw()
	{
		super.draw();
		_glow.draw();
	}
	
}