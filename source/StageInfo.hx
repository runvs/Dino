package;
import haxe.Json;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class StageInfo
{
	public static var AllStages (default, null) : Array<StageItem>;
	public static var StageNumberMax : Int;
	
	public static function loadStages(path : String = "assets/data/stages.json")
	{
		trace("load stages");
		AllStages = new Array<StageItem>();
		var data : Stages;
		data = Json.parse(Assets.getText(path));
		StageNumberMax = -1;
		for ( i in 0...data.stages.length)
		{
			var s : StageItem = new StageItem(
			data.stages[i].name, 
			Std.int(data.stages[i].stage), Std.int(data.stages[i].episode), 
			data.stages[i].type, data.stages[i].actor,
			data.stages[i].level);
			
			s.setRequirements(data.stages[i].requirements);
			s.setStorySettings(data.stages[i].storysettings);
			
			AllStages.push(s);
			
			if (s.stage >= StageNumberMax)
				StageNumberMax = s.stage;
		}
		trace("I have added " + AllStages.length + " StageItems");
	}
	
	
	public static function getStage(n : String ) : StageItem
	{
		for (i in 0 ... AllStages.length)
		{
			var s : StageItem = AllStages[i];
			
			if (s.name == n)
				return s;
		}
		
		throw "ERROR: Could not find a Stage with name " + n;
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
	var actor : String;	// dino, dinobag, baby
	var level : String;	// json file for cutscenes, level name for play or gather
	var requirements : Array<String>;
	var storysettings : Array<String>;
}