package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Exit extends ConditionalObject
{

	public var targetStage : String = "";
	public var type : String = "";

	public function new() 
	{
		super();
		cameras = [GP.CameraMain];
	}
	
	public function perform()
	{
		StageInfo.getStage(targetStage).startStage();
	}
	
	
}