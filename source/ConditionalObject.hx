package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class ConditionalObject extends FlxSprite
{

	public var conditions: Array<String>;
	
	public function new() 
	{
		super();
		conditions = new Array<String>();
	}
	
	public function checkConditions() : Bool
	{
		for (s in conditions)
		{
			var smv : Bool = StoryManager.getBool(s);
			if ( smv == false)
			{
				return false;
			}
		}
		return true;
	}
	
	public function createConditions ( s: String)
	{
		if (s == null) return; 	// nothing to do here
		if (s == "") return;
		
		var split : Array<String> = s.split(",");
		for (i in 0... split.length)
		{
			var c : String = split[i];
			c = StringTools.ltrim(c);
			c = StringTools.rtrim(c);
			
			conditions.push(c.toLowerCase());
		}
	}
	
}