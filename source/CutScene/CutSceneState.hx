package ;

//import ActionAnimation;
//import CutSceneAction;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class CutSceneState extends BasicState
{
	var _timer : Float = 0;	
	
	var _positions : Array<CutScenePosition>;
	var _actors : Array<CutSceneActor>;
	var _actions : Array<CutSceneAction>;
	
	var _speechbubbles : Array<SpeechBubble>;
	
	var _name: String;
	
	// this overlay is for fading in cutscenes
	public var _overlay2 : FlxSprite;
	
	override public function new (n:String)
	{
		trace("CutSceneState new pre super(), number of cameras: " + FlxG.cameras.list.length);
		super(); 	
		trace("CutSceneState new post super(), number of cameras: " + FlxG.cameras.list.length);
		_name = n;
		
		_overlay2 = new FlxSprite(0, 0);
		_overlay2.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_overlay2.scrollFactor.set();
		_overlay2.alpha = 0.0;		
	}
	
	override public function create():Void
	{
		trace("CutSceneState create pre super(), number of cameras: " + FlxG.cameras.list.length);
		super.create();
		trace("CutSceneState create post super(), number of cameras: " + FlxG.cameras.list.length);
		_actions = new Array<CutSceneAction>();
		_actors = new Array<CutSceneActor>();
		_speechbubbles = new Array<SpeechBubble>();
		_positions = new Array<CutScenePosition>();
		
		parseJsonData();
	}

		
	function parseJsonData():Void 
	{
		var data : CutSceneData;
		data = Json.parse(Assets.getText(_name));
		if (data.level != null)
		{
			_levelName = data.level;
			LoadLevel(_levelName);
		}
		for (i in 0...data.positions.length)
		{
			var p : CutScenePosition = new CutScenePosition(data.positions[i].x, data.positions[i].y, data.positions[i].name);
			_positions.push(p);
		}
		//trace("converting Positions done");
		
		for (i in 0...data.actors.length)
		{
			createActor(data.actors[i]);
		}
		
		for (i in 0...data.actions.length)
		{			
			convertAction(data.actions[i]);
		}
		
		if (data.follow != null)
		{
			var ac : CutSceneActor = getActor(data.follow);
			if (ac != null)
			{
				GP.CamerasFollow(ac, ac.overlay);
			}
		}
	}
	
	
	override public function internalUpdate(elapsed:Float):Void
	{
		_timer += elapsed;
		for (a in _actions)
		{
			a.update(elapsed);
			if (a.performed) continue;
			if (a.trigger) a.perform(this);
		}
		
		for (a in _actors)
		{
			a.update(elapsed);
		}
		
		for (s in _speechbubbles)
		{
			s.update(elapsed);
		}
		clearBubbles();
	}
	
	public override function internalDrawTop() : Void
	{
		_overlay2.draw();
	}
	override public function internalDraw () :  Void 
	{
		for (s in _speechbubbles)
		{
			s.draw();
		}
		for (i in 0..._actors.length)
		{
			_actors[i].draw();
		}
	}
	
	
	function createActor(ad:ActorData) 
	{
		var a : CutSceneActor = new CutSceneActor(ad.name);
		var p : CutScenePosition = getPosition(ad.position);
		if (p != null)
		{
			//trace("Actor: " + a.name + " setposition x/y" + p.x + " " + p.y);
			a.setPosition(p.x, p.y);
		}
		_actors.push(a);
	}
	
	function convertAction(a:ActionData) 
	{
		if (a.time < 0) 
			throw "Action Error: Time must not be negative!";
		
			var action : CutSceneAction = null;
			
			if (a.type == "animate")
			{
				var f : Bool = (a.p2 == "true"? true : false);
				action = new CutSceneActionAnimation(a.actor, a.p1, f);
			}
			else if (a.type == "speak")
			{
				var d : Float = Std.parseFloat(a.p2);
				action = new CutSceneActionSpeak(a.actor, a.p1, d);
			}
			else if (a.type == "move")
			{
				var d : Float = Std.parseFloat(a.p2);
				action = new CutSceneActionMove(a.actor, a.p1, d);
			}
			else if (a.type == "wiggle")
			{
				throw "Action wiggle not implemented yet";
			}
			else if (a.type == "fade")
			{
				var ta : Float = Std.parseFloat(a.p1);
				var duration : Float = Std.parseFloat(a.p2);
				action = new CutSceneActionFade(a.actor, ta, duration);
			}
			else if (a.type == "sound")
			{
				throw "Action Sound not implemented yet";
			}
			else if (a.type == "end")
			{
				action = new CutSceneActionEnd(a.actor, a.p1);
			}
			else
			{
				throw "Action Error: Type " + a.type + " not known!";
			}
			
			action.timer = a.time;
			_actions.push(action);
	}
	
	function clearBubbles() 
	{
		var newlist = new Array<SpeechBubble>();
		for (s in _speechbubbles) { if (s.alive) newlist.push(s); }
		_speechbubbles = newlist;
	}

	
	public function getPosition (name :String) : CutScenePosition
	{
		var ret : CutScenePosition = null;
		for (p in _positions)
		{		
			if (p.name == name)
			{
				ret = p;
				break;
			}
		}
		return ret;
	}
	
	public function getActor (name :String) : CutSceneActor
	{
		var ret : CutSceneActor = null;
		
		for (a in _actors)
		{
			if (a.name == name)
			{
				ret = a;
				break;
			}
		}
		return ret;
	}
	
	public function addSpeechBubble (s : SpeechBubble)
	{
		_speechbubbles.push(s);
	}
	
}



typedef ActionData = 
{
	var actor : String;
	var time : Float;
	var type : String;
	var p1 : String;
	var p2 : String;
}

typedef ActorData =
{
	var name : String;
	var position : String;
}

typedef PositionData =
{
	var x : Float;
	var y : Float;
	var name : String;
}

typedef CutSceneData = 
{
	var positions : Array<PositionData>;
    var actors : Array<ActorData>;
	var actions : Array<ActionData>;
	var follow : String;
	var level : String;
}


