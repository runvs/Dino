package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class HurtingSprite extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
	}
	
	private function LoadHurtingGraphic(tileType:Int)
	{
		this.immovable = true;
		this.loadGraphic(AssetPaths.tileset__png, true, GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel);
		this.animation.add("idle", [tileType]);
		this.animation.play("idle");
		this.cameras = [GP.CameraMain];
	}
	
}