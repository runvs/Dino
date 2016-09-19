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
		
		_valuesBool.set(k, v);
	}
}