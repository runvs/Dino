package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class HurtingSprite extends FlxSprite
{
	private var _playerPosition : FlxPoint;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		_playerPosition = new FlxPoint();
	}
	
	public function setPlayerPosition(px : Float, py : Float)
	{
		_playerPosition.set(px, py);
	}
	
	private function LoadHurtingGraphic(tileType:Int)
	{
		
		this.immovable = true;
		this.loadGraphic(AssetPaths.tileset_new__png, true, GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel);
		this.animation.add("idle", [tileType]);
		this.animation.play("idle");
		this.cameras = [GP.CameraMain];
	}
}