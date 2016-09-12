package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;



class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		
		
		// TODO Check if camera list has to be cleared
		GP.CamerasCreate();
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//FlxG.switchState(new PlayState(AssetPaths.level_E__tmx));
		FlxG.switchState(new CutSceneState(AssetPaths.scene_test__json));
	}
}
