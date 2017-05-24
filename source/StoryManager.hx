package;

/**
 * ...
 * @author 
 */
class StoryManager
{

	private static var _valuesBool : Map<String, Bool> = new Map<String,Bool>();
	
	public static function getBool (k : String) : Bool
	{
		if (k == null)
			throw "ERROR in StoryManager.get: Key is null";
		
		return _valuesBool.get(k);
	}
	
	public static function setBool (k:String, v :Bool)
	{
		if (k == null)
			throw "ERROR in StoryManager.set: Key is null";
		
		//if (v == true)
			//trace("setting " + k + " to true");
		_valuesBool.set(k, v);
	}
	
	public static function reset()
	{
		trace("resetting all story values");
		for (k in _valuesBool.keys())
		{
			_valuesBool.set(k, false);
		}
	}
}