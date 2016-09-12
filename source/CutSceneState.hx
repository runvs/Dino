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
	
	var _positions : Array<PositionData>;
	var _actors : Array<CutSceneActor>;
	var _actions : Array<CutSceneAction>;
	
	var _speechbubbles : FlxSpriteGroup;
	
	var _name: String;
	
	override public function new (n:String)
	{
		super(); 	
		_name = n;
	}
	
	override public function create():Void
	{
		super.create();

		_actions = new Array<CutSceneAction>();
		_actors = new Array<CutSceneActor>();
		
		trace("creating scene " + _name);
		
		var data : CutSceneData;
		data = Json.parse(Assets.getText(_name));
		
		_positions = data.positions;
		_speechbubbles = new FlxSpriteGroup();
		
		
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
		var p : PositionData = getPosition(ad.position);
		if (p != null)
		{
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
		
		_speechbubbles.update(elapsed);
		clearBubbles();
	}
	
	function clearBubbles() 
	{
		var newlist = new FlxSpriteGroup();
		_speechbubbles.forEach(function (s) { if (s.alive) newlist.add(s); } );
		_speechbubbles = newlist;
	}
	
	override public function draw () :  Void 
	{
		super.draw();
		_speechbubbles.draw();
		for (i in 0..._actors.length)
		{
			_actors[i].draw();
		}
		
	}
	
	public function getPosition (name :String) : PositionData
	{
		var ret : PositionData = null;
		
		for (i in 0... _positions.length)
		{
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
		_speechbubbles.add(s);
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


typedef CutSceneData = 
{
	var positions : Array<PositionData>;
    var actors : Array<ActorData>;
	var actions : Array<ActionData>;
	var follow : String;
}


