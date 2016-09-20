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
	var _stages : Array< Array<StageItem> >;

	var _selectionSprite : FlxSprite;
	
	var _currentSelectionX : Int;
	var _currentSelectionY : Int;
	
	var _inputTimer : Float = 0;
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		GP.CamerasCreate();
		StageInfo.loadStages();
		
		
		
		var commitText : FlxText = new FlxText(5, 560, 0, Version.getGitCommitHash() + " built on " + Version.getBuildDate() + "\n" + Version.getGitCommitMessage(), 8);
		commitText.cameras = [GP.CameraOverlay];
		commitText.scrollFactor.set(0, 0);
		add(commitText);
		
		
		var allStages : Array<StageItem> = StageInfo.AllStages;
		
		//trace("creating stage layers");
		_stages = new Array < Array < StageItem > > ();
		for (i in 0...StageInfo.StageNumberMax+1)
		{
			_stages.push(new Array < StageItem>() );
		}
		
		//trace("pushing stages to correct layer");
		for ( i in 0... allStages.length)
		{
			var s : StageItem = allStages[i];
			_stages[s.stage].push(s);
		}
		
		//trace("sorting stages");
		for ( i in 0 ... _stages.length)
		{
			ArraySort.sort(_stages[i], StageItem.compareEpisodeNumber);
			//trace(_stages[i].length);
		}
		
		//trace("creating selection sprite");
		_selectionSprite = new FlxSprite(GP.MenuItemsOffsetX, GP.MenuItemsOffsetY);
		_selectionSprite.makeGraphic(Std.int(GP.MenuItemsSize), Std.int(GP.MenuItemsSize));
		_selectionSprite.alpha = 0.3;
		_selectionSprite.cameras = [GP.CameraMain];
		add(_selectionSprite);
	}

	override public function update(elapsed:Float):Void
	{
		//trace("update");
		MyInput.update();
		
		super.update(elapsed);
		
		if (_inputTimer >= 0) _inputTimer -= elapsed;
		
		//trace("selection");
		UpdateSelection();
		
		//trace("setposition");
		_selectionSprite.setPosition(
		GP.MenuItemsOffsetX + (GP.MenuItemsPadding + GP.MenuItemsSize) * _currentSelectionX,
		GP.MenuItemsOffsetY + (GP.MenuItemsPadding + GP.MenuItemsSize) * _currentSelectionY
		);
		
		//trace("Input");
		if (MyInput.AttackButtonJustPressed || MyInput.JumpButtonJustPressed )
		{
			_stages[_currentSelectionY][_currentSelectionX].startStage();
		}
		//trace("end");
	}
	
	override public function draw()
	{
		//trace("draw");
		for (i in 0 ... _stages.length)
		{
			for (j in 0 ... _stages[i].length)
			{
				//trace(_stages[i]);
				//trace(_stages[i][j]);
				_stages[i][j].draw();
			}
		}
		
		//trace("superdraw");
		super.draw();
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
