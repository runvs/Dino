package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;
using Lambda;


class MenuState extends FlxState
{
	var _stageDataFileName : String = "assets/data/stages.json";
	
	var _stages : FlxSpriteGroup;
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		
		
		// TODO Check if camera list has to be cleared
		GP.CamerasCreate();
		var data : Stages;
		data = Json.parse(Assets.getText(_stageDataFileName));
		
		_stages = new FlxSpriteGroup();
		_stages.cameras = [GP.CameraMain];
		
		
		var commitText : FlxText = new FlxText(5, 560, 0, Version.getGitCommitHash() + " built on " + Version.getBuildDate() + "\n" + Version.getGitCommitMessage(), 8);
		commitText.cameras = [GP.CameraOverlay];
		commitText.scrollFactor.set(0, 0);
		add(commitText);
		
		
		for ( i in 0...data.stages.length)
		{
			var s : StageItem = new StageItem(data.stages[i].name, Std.int(data.stages[i].stage), Std.int(data.stages[i].episode));
			
			s.setRequirements(data.stages[i].requirements);
			s.setStorySettings(data.stages[i].storysettings);
			
			_stages.add(s);
		}
		add(_stages);
		
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		for (i in 0..._stages.length)
		{
			//var s : StageItem = _stages.members[i];
			
			
			
		}
		//FlxG.switchState(new CutSceneState(AssetPaths.scene_test__json));
	}
}

typedef Stages = 
{
	var stages : Array<StageData>;
}

typedef StageData =
{
	var name : String;
	var stage: Float;
	var episode : Float;
	var type : String;	// cut, play, gather, ...
	var level : String;	// json file for cutscenes, level name for play or gather
	var requirements : Array<String>;
	var storysettings : Array<String>;
}