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
import flixel.util.FlxTimer;

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
		//trace("Playstate create");
		
		super.create();
		LoadLevel(_levelName);
		
	
		//trace("Playstate create mid");
		
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
		//trace("Playstate create end");
	}
	
	
	
	override public function internalUpdate(elapsed:Float):Void
	{	
		//trace("PlayState internal Update");
		_level.wind.setDinoPosition(d);
		d.update(elapsed);
		FlxG.collide(d, _level.collisionMap);
		d.touchedGround = d.isTouching(FlxObject.DOWN);
		
		
		_infostring.text += "\nDino Position" + Std.int(d.x) + ", " + Std.int(d.y) + "\n";
		
		CheckSpeechBubbleAreas();
		CheckExits();
		for (e in _level.exits)
		{
			e.update(elapsed);
		}
		for (e in _level.entries)
		{
			e.update(elapsed);
		}
		for (d in _level.doors)
		{
			d.setDinoPosition(this.d);
		}
		for (e in _level.enemies)
		{
			if (!e.alive) continue;
			
			if (FlxG.overlap(d, e))
			{
				if (FlxG.pixelPerfectOverlap(d._sprite, e._sprite))
				{
					DinoDie();
				}
			}
			
			e.update(elapsed);
		}
		
		for (s in _level.movingTiles)
		{
			s.setDino(d);
			FlxG.collide(d, s, function(d, s : MovingTile) { if (s.isTouching(FlxObject.UP)) s.touchMe(); } );
			if (d.touchedGround == false)		
			{
				d.touchedGround = d.isTouching(FlxObject.DOWN);
			}
		}
		
		for (h in _level.hurtingTiles)
		{
			if (!h.alive) continue;
			h.setPlayerPosition(d.x, d.y);
			
			if (FlxG.overlap(d, h))
			{
				//trace("overlap");
				if (FlxG.pixelPerfectOverlap(d._sprite, h, 0))
				{
					//trace("pp overlap");
					DinoDie();
				}
			}
		}
	}
	
	
	function CheckSpeechBubbleAreas() 
	{
		//trace(_speechbubbles.lengt());
		for (sba in _level.speechBubbleAreas)
		{
			if (FlxG.overlap(d, sba))
			{
				if (_speechbubbles.getSpeechBubble(sba._name) == null)
				{
					// no speechbubble present, so add it
					var s : SpeechBubble = sba.getSpeechBubble(d);
					_speechbubbles.addSpeechBubble(s);
				}
			}

		}
		
		for (s in _speechbubbles._speechbubbles)
		{
			if (s.disappearing) continue;

			var stayAlive : Bool = true;
			
			for (sba in _level.speechBubbleAreas)
			{
				if (sba._name == s.name)
				{
					if ( !FlxG.overlap(d, sba) || !sba.checkConditions())
					{
						s.MakeBubbleDisappear();
					}
				}
			}
		}
	}
	
	
	override public function internalDraw ()
	{
		//trace("PlayState internal draw");
		
		//for (s in _level.collisionMap)
		//{
			//s.draw();
		//}
		
		d.draw();
		
		
		for (e in _level.exits)
		{
			e.draw();
		}
		for (e in _level.entries)
		{
			//e.draw();
		}
		for (e in _level.enemies)
		{
			e.draw();
		}
		//d.tracer.draw();
		
		_overlay.draw();
	}
	
	function DinoDie()
	{
		
		if (d.inputEnabled == false) return;
		trace("out");
		
		var T : Float = 1.0;
		
		d.inputEnabled = false;
		d._sprite.angle = 90;
		d._sprite.color = FlxColor.GRAY;
		var t : FlxTimer = new FlxTimer();
		t.start(T, function ( t) { RestartMap(); } );
		//GP.CameraOverlay.fade(FlxColor.BLACK, 0.7, false, function(){});
		FlxTween.tween(_overlay, { alpha:1 }, T/2, {startDelay: T/2-0.1, type:FlxTween.PERSIST} );
		
	}
	
	function RestartMap() 
	{
		LoadLevel(_levelName);
		d._sprite.angle = 0;
		d._sprite.color = FlxColor.WHITE;
		jumpToEntryPoint(1);
		d.inputEnabled = true;
		//_overlay.alpha = 0;
		FlxTween.tween(_overlay, { alpha:0 }, 0.75);
	}
	
	function CheckExits() 
	{
		d.isOnExit = false;
		for (e in _level.exits)
		{
			if (!e.canBeUsed()) continue;
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
	
	
	override public function jumpToEntryPoint (id : Int )
	{
		super.jumpToEntryPoint(id);
		d.teleport(_level.getEntryPoint(id).x, _level.getEntryPoint(id).y);
		d.update(0.1);// to update d.tracer
		GP.CamerasFollow(d, d.tracer);
	}
	
	
	
	public function getDinoPosition () : FlxPoint
	{
		return new FlxPoint(d.x, d.y);
	}
	
	override public function LoadLevel(l:String) 
	{
		super.LoadLevel(l);
		for (e in _level.enemies)
		{
			e.setState(this);
		}
	}
}
