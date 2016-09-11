package ;

//import ActionAnimation;
//import CutSceneAction;
import flixel.FlxState;
import haxe.Json;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class CutSceneState extends FlxState
{
	var _timer : Float;	
	var _actions : Array<CutSceneAction>;
	var _actors : Array<CutSceneActor>;
	
	
	override public function create():Void
	{
		super.create();
		
		_actions = new Array<CutSceneAction>();
		_actors = new Array<CutSceneActor>();
		
		var data : CutSceneData;
		data = Json.parse(Assets.getText(AssetPaths.scene_test__json));
		
		for (i in 0...data.actors.length)
		{
			createActor(data.actors[i]);
		}
		
		
		for (i in 0...data.actions.length)
		{			
			convertAction(data.actions[i]);
		}
		
		_timer = 0;
	}
	
	function createActor(ad:ActorData) 
	{
		var a : CutSceneActor = new CutSceneActor(ad.name);
		_actors.push(a);
	}
	
	function convertAction(a:ActionData) 
	{
		if (a.time < 0) 
			throw "Action Error: Time must not be negative!";
		if (a.actor != "dino" && a.actor != "baby" && a.actor != "mole" && a.actor != "egg" && a.actor != "global")
			throw "Action Error: Actor " + a.actor  + " not known!";
		
			var action : CutSceneAction = null;
			
			if (a.type == "animate")
			{
				var f : Bool = (a.p2 == "true"? true : false);
				action = new CutSceneActionAnimation(a.actor, a.p1, f);
			}
			else if (a.type != "speak")
			{
				var d : Float = Std.parseFloat(a.p2);
				action = new CutSceneActionSpeak(a.actor, a.p1, d);
			}
			else if (a.type != "move")
			{
				var d : Float = Std.parseFloat(a.p2);
				action = new CutSceneActionMove(a.actor, a.p1, d);
			}
			else if (a.type != "wiggle")
			{
				throw "Action wiggle not implemented yet";
			}
			else if (a.type != "fade")
			{
				var ta : Float = Std.parseFloat(a.p1);
				var duration : Float = Std.parseFloat(a.p2);
				action = new CutSceneActionFade(a.actor, ta, duration);
			}
			else if (a.type != "sound")
			{
				throw "Action Sound not implemented yet";
			}
			else if (a.type != "end")
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
	}
	
	override public function draw () :  Void 
	{
		super.draw();
		for (i in 0..._actors.length)
		{
			_actors[i].draw();
		}
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
    var actions : Array<ActionData>;
	var actors : Array<ActorData>;
}

