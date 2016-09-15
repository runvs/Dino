package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends BasicState
{
	var d : Dino;
	
	public function new ( n : String )
	{
		super();
		_levelName =  n;
	}
	
	override public function create():Void
	{
		super.create();
		trace("PlayState Create");
		LoadLevel();
		
		d = new Dino();
		d.setPosition(_level.getEntryPoint(1).x, _level.getEntryPoint(1).y);
		trace("PlayState Camera Follow");
		GP.CameraMain.follow(d, FlxCameraFollowStyle.LOCKON, 0.20);
		GP.CameraOverlay.follow(d.overlay, FlxCameraFollowStyle.LOCKON , 0.20);
	}
	
	override public function internalUpdate(elapsed:Float):Void
	{	
		//trace("PlayState internal Update");
		d.update(elapsed);
		FlxG.collide(d, _level.collisionMap);
		d.touchedGround = d.isTouching(FlxObject.DOWN);
		
		CheckExits();
		for (e in _level.exits)
		{
			e.update(elapsed);
		}
		for (e in _level.entries)
		{
			e.update(elapsed);
		}
	}
	
	function CheckExits() 
	{
		d.isOnExit = false;
		for (e in _level.exits)
		{
			if (e.targetLevel == "") continue;
			if (FlxG.overlap(d, e))
			{
				
				trace("overlap");
				d.isOnExit = true;
				if (d.transport)
					SwitchLevel(e);
				break;
			}
		}
	}
	
	function SwitchLevel(e:Exit) 
	{
		_levelName = "assets/data/" + e.targetLevel;
		LoadLevel();
		
		var p : FlxPoint = _level.getEntryPoint(e.entryID);
		d.teleport(p.x, p.y);
	}
	
	override public function internalDraw ()
	{
		//trace("PlayState internal draw");
		d.draw();
		_level.topTiles.draw();
		for (e in _level.exits)
		{
			e.draw();
		}
		for (e in _level.entries)
		{
			e.draw();
		}
	}
}
