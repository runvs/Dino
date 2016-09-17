package;

/**
 * ...
 * @author 
 */
class StoryManager
{

	private static var _values : Map<String, Bool> = new Map<String,Bool>();
	
	public static function get (k : String) : Bool
	{
		if (k == null)
			throw "ERROR in StoryManager.get: Key is null";
		
		return _values.get(k);
	}
	
	public static function set (k:String, v :Bool)
	{
		if (k == null)
			throw "ERROR in StoryManager.set: Key is null";
		
		_values.set(k, v);
	}
	
}