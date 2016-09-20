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
import haxe.ds.ArraySort;
import openfl.Assets;
using Lambda;


class MenuState extends FlxState
{
	var _stageDataFileName : String = "assets/data/stages.json";
	
	var _maxStageNumber : Int;
	var _stages : Array< Array<StageItem> >;

	var _selectionSprite : FlxSprite;
	
	var _currentSelectionX : Int;
	var _currentSelectionY : Int;
	
	var _inputTimer : Float = 0;
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		
		
		// TODO Check if camera list has to be cleared
		GP.CamerasCreate();
		var data : Stages;
		data = Json.parse(Assets.getText(_stageDataFileName));
		
		
		
		
		var commitText : FlxText = new FlxText(5, 560, 0, Version.getGitCommitHash() + " built on " + Version.getBuildDate() + "\n" + Version.getGitCommitMessage(), 8);
		commitText.cameras = [GP.CameraOverlay];
		commitText.scrollFactor.set(0, 0);
		add(commitText);
		
		
		var allStages : Array<StageItem> = new Array<StageItem>();
		
		
		_maxStageNumber = -1;
		for ( i in 0...data.stages.length)
		{
			var s : StageItem = new StageItem(
			data.stages[i].name, 
			Std.int(data.stages[i].stage), Std.int(data.stages[i].episode), 
			data.stages[i].type, data.stages[i].level);
			
			s.setRequirements(data.stages[i].requirements);
			s.setStorySettings(data.stages[i].storysettings);
			
			allStages.push(s);
			
			if (s.stage >= _maxStageNumber)
				_maxStageNumber = s.stage;
			
		}
		trace("I have added " + allStages.length + " stages");
		
		_stages = new Array < Array < StageItem > > ();
		for (i in 0..._maxStageNumber+1)
		{
			_stages.push(new Array < StageItem>() );
		}
		
		for ( i in 0... allStages.length)
		{
			var s : StageItem = allStages[i];
			_stages[s.stage].push(s);
		}
		
		for ( i in 0 ... _stages.length)
		{
			ArraySort.sort(_stages[i], StageItem.compareEpisodeNumber);
		}
		
		
		
		_selectionSprite = new FlxSprite(GP.MenuItemsOffsetX, GP.MenuItemsOffsetY);
		_selectionSprite.makeGraphic(Std.int(GP.MenuItemsSize), Std.int(GP.MenuItemsSize));
		_selectionSprite.alpha = 0.3;
		_selectionSprite.cameras = [GP.CameraMain];
		add(_selectionSprite);
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		
		if (_inputTimer >= 0) _inputTimer -= elapsed;
		
		UpdateSelection();
		
		_selectionSprite.setPosition(
		GP.MenuItemsOffsetX + (GP.MenuItemsPadding + GP.MenuItemsSize) * _currentSelectionX,
		GP.MenuItemsOffsetY + (GP.MenuItemsPadding + GP.MenuItemsSize) * _currentSelectionY
		);
		
		if (MyInput.AttackButtonJustPressed || MyInput.JumpButtonJustPressed )
		{
			_stages[_currentSelectionY][_currentSelectionX].startStage();
		}
	}
	
	function UpdateSelection() 
	{
		if (_inputTimer <= 0)
		{
			if (MyInput.xVal > 0.5)
			{
				_inputTimer += 0.2;
				MoveSelectionRight();
				
			}
			else if (MyInput.xVal < -0.5)
			{
				_inputTimer += 0.2;
				MoveSelectionLeft();
				
			}
			
			if (MyInput.yVal > 0.5)
			{
				_inputTimer += 0.2;
				MoveSelectionDown();
			}
			else if (MyInput.yVal < -0.5)
			{
				_inputTimer += 0.2;
				MoveSelectionUp();
			}
		}
	}
	
	
	function MoveSelectionUp() 
	{
		var targetEpisode : Int = _currentSelectionX;
		var targetStage : Int = _currentSelectionY - 1;
		
		// fix X position (stage)
		if (targetStage < 0 )
		{
			targetStage = _stages.length - 1;
		}
		
		if (targetStage >= _stages.length)
		{
			targetStage = 0;
		}
		
		// fix y position (episode) // go left
		while (targetEpisode >= _stages[targetStage].length)
		{
			targetEpisode -= 1;
		}
		if (targetEpisode < 0 ) targetEpisode = 0;
		_currentSelectionX = targetEpisode;
		_currentSelectionY = targetStage;
	}
	
	function MoveSelectionDown() 
	{
		var targetEpisode : Int = _currentSelectionX;
		var targetStage : Int = _currentSelectionY + 1;
		
		// fix X position (stage)
		if (targetStage < 0 )
		{
			targetStage = _stages.length - 1;
		}
		
		if (targetStage >= _stages.length)
		{
			targetStage = 0;
		}
		
		// fix y position (episode) // go left
		while (targetEpisode >= _stages[targetStage].length)
		{
			targetEpisode -= 1;
		}
		if (targetEpisode < 0 ) targetEpisode = 0;
		_currentSelectionX = targetEpisode;
		_currentSelectionY = targetStage;
	}
	
	function MoveSelectionLeft() 
	{
		var targetEpisode : Int = _currentSelectionX - 1;
		var targetStage : Int = _currentSelectionY ;
		
		// fix X position (stage)
		if (targetStage < 0 )
		{
			targetStage = _stages.length - 1;
		}
		
		if (targetStage >= _stages.length)
		{
			targetStage = 0;
		}
		
		// fix y position (episode) // go left
		while (targetEpisode >= _stages[targetStage].length)
		{
			targetEpisode -= 1;
		}
		if (targetEpisode < 0 ) targetEpisode = 0;
		_currentSelectionX = targetEpisode;
		_currentSelectionY = targetStage;
	}
	
	function MoveSelectionRight() 
	{
		var targetEpisode : Int = _currentSelectionX + 1;
		var targetStage : Int = _currentSelectionY ;
		
		// fix X position (stage)
		if (targetStage < 0 )
		{
			targetStage = _stages.length - 1;
		}
		
		if (targetStage >= _stages.length)
		{
			targetStage = 0;
		}
		
		// fix y position (episode) // go left
		while (targetEpisode >= _stages[targetStage].length)
		{
			targetEpisode -= 1;
		}
		if (targetEpisode < 0 ) targetEpisode = 0;
		_currentSelectionX = targetEpisode;
		_currentSelectionY = targetStage;
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