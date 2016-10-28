package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends BasicState
{
	var d : PlayableCharacter;
	var _actorName : String;
	public function new ( n : String, a : String )
	{
		super();
		_levelName =  n;
		_actorName = a;
	}
	
	override public function create():Void
	{
		trace("Playstate create");
		
		super.create();
		LoadLevel(_levelName);
		trace("Playstate create mid");
		
		var hasBag : Bool = _actorName == "dinobag";
		if (hasBag)
		{
			d = new DinoBag();
		}
		else
		{
			d = new Dino();
		}
		
		jumpToEntryPoint(1);
		trace("Playstate create end");
		
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
			if (!e.checkConditions()) continue;
			if (FlxG.overlap(d, e))
			{
				if (e.type == "enter")
				{
					//trace("overlap");
					d.isOnExit = true;
					if (d.transport)
					{
						e.perform(this);
					}
					break;
				}
				else if (e.type == "touch")
				{
					e.perform(this);
				}
			}
		}
	}
	
	override public function internalDraw ()
	{
		//trace("PlayState internal draw");
		d.draw();
		
		for (e in _level.exits)
		{
			//e.draw();
		}
		for (e in _level.entries)
		{
			//e.draw();
		}
		//d.tracer.draw();
		
		
	}
	
	override public function jumpToEntryPoint (id : Int )
	{
		d.teleport(_level.getEntryPoint(1).x, _level.getEntryPoint(1).y);
		d.update(0.1);// to update d.tracer
		GP.CamerasFollow(d, d.tracer);
	}
}
