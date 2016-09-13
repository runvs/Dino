package ;

//import ActionAnimation;
//import CutSceneAction;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class CutSceneState extends FlxState
{
	var _timer : Float;	
	
	var _positions : Array<CutScenePosition>;
	var _actors : Array<CutSceneActor>;
	var _actions : Array<CutSceneAction>;
	
	var _speechbubbles : Array<SpeechBubble>;
	
	var _name: String;
	
	override public function new (n:String)
	{
		super(); 	
		_name = n;
	}
	
	override public function create():Void
	{
		super.create();
		GP.CamerasCreate();
		
		_actions = new Array<CutSceneAction>();
		_actors = new Array<CutSceneActor>();
		
		trace("creating scene " + _name);
		
		var data : CutSceneData;
		trace("parsing started");
		data = Json.parse(Assets.getText(_name));
		trace("parsing complete");
		
		trace("converting Positions");
		_positions = new Array<CutScenePosition>();
		for (i in 0...data.positions.length)
		{
			var p : CutScenePosition = new CutScenePosition(data.positions[i].x, data.positions[i].y, data.positions[i].name);
			_positions.push(p);
		}
		trace("converting Positions done");
		
		_speechbubbles = new Array<SpeechBubble>();
		
		
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
				GP.CameraMain.follow(ac);
			}
		}
		
		_timer = 0;
	}
	
	function createActor(ad:ActorData) 
	{
		
		var a : CutSceneActor = new CutSceneActor(ad.name);
		var p : CutScenePosition = getPosition(ad.position);
		if (p != null)
		{
			trace("Actor: " + a.name + " setposition x/y" + p.x + " " + p.y);
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
				action = new CutSceneActionEnd(a.actor, a.p1, a.p2);
			}
			else
			{
				throw "Action Error: Type " + a.type + " not known!";
			}
			
			action.timer = a.time;
			_actions.push(action);
			
	}
	
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_timer += elapsed;
		
		for (i in 0..._actions.length)
		{
			var a : CutSceneAction = _actions[i];
			a.update(elapsed);
			if (a.performed) continue;
			if (a.trigger) a.perform(this);
		}
		
		for (i in 0..._actors.length)
		{
			_actors[i].update(elapsed);
		}
		
		for (s in _speechbubbles)
		{
			s.update(elapsed);
		}
		clearBubbles();
	}
	
	function clearBubbles() 
	{
		var newlist = new Array<SpeechBubble>();
		for (s in _speechbubbles) { if (s.alive) newlist.push(s); }
		_speechbubbles = newlist;
	}
	
	override public function draw () :  Void 
	{
		super.draw();
		for (s in _speechbubbles)
		{
			s.draw();
		}
		for (i in 0..._actors.length)
		{
			_actors[i].draw();
		}
		
	}
	
	public function getPosition (name :String) : CutScenePosition
	{
		var ret : CutScenePosition = null;
		trace("getPosition");
		trace("_positions.length " + _positions.length);
		trace("name " + name);
		for (i in 0... _positions.length)
		{
			
			trace("i: " + i + " data: " + _positions[i]);
			trace("i: " + i + " name: " + _positions[i].name);
			if (_positions[i].name == name)
			{
				ret = _positions[i];
				break;
			}
		}
		return ret;
	}
	
	public function getActor (name :String) : CutSceneActor
	{
		var ret : CutSceneActor = null;
		
		for (i in 0..._actors.length)
		{
			if (_actors[i].name == name)
			{
				ret = _actors[i];
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
}


