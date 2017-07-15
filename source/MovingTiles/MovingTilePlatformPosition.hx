package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class MovingTilePlatformPosition extends FlxSprite
{
	public var wait : Float = 0;
	public var name : String = "";

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		//this.makeGraphic(4, 4, FlxColor.PINK);
	}
	
	
}