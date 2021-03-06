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

	public function new(w:Int, h:Int, l : Float, r: Float) 
	{
		super(w,h,l, r);
		cameras = [GP.CameraMain];
	}
	
	private override function doPerform(stage : BasicState)
	{

		StageInfo.getStage(targetStage).startStage();
				
	}
	
	
}