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
	public var name :String;
	public var invert : Array<Bool>;
	
	public function new() 
	{
		super();
		conditions = new Array<String>();
		invert = new Array<Bool>();
	}
	
	public function checkConditions() : Bool
	{
		for (i in 0...conditions.length)
		{
			var s : String = conditions[i];
			var n : Bool = invert[i];
			var smv : Bool = StoryManager.getBool(s);
			
			if ( smv == n)
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
		
		//trace("creating conditions");
		var split : Array<String> = s.split(",");
		for (i in 0... split.length)
		{
			
			
			var c : String = split[i];
			//trace(c);
			c = StringTools.ltrim(c);
			c = StringTools.rtrim(c);
			var i : Bool = false;
			//trace(c);
			if (c.indexOf("!") != -1)
			{
				trace("negate condition");
				c = StringTools.replace(c, "!", "");
				i = true;
			}
			//trace("    " + c.toLowerCase());
			conditions.push(c.toLowerCase());
			invert.push(i);
		}
	}
	
	
	
}