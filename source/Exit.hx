package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Exit extends LevelLeaver
{

	public var targetStage : String = "";

	public function new(w:Int, h:Int) 
	{
		super(w,h);
		cameras = [GP.CameraMain];
	}
	
	public override function perform(stage : BasicState)
	{
		StageInfo.getStage(targetStage).startStage();
	}
	
	
}