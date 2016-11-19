package;

import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author 
 */
class EndState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		
		// TODO Check if camera list has to be cleared
		//GP.CamerasCreate();
		
		
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		//FlxG.switchState(new PlayState(AssetPaths.level_E__tmx));
		if ( MyInput.JumpButtonJustPressed)
		{
			FlxG.switchState(new CutSceneState(AssetPaths.scene_test__json));
		}
	}
	
}