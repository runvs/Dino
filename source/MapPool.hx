package;
import haxe.Json;
import haxe.ds.StringMap;
import openfl.Assets;
/**
 * ...
 * @author 
 */
class MapPool
{
	
	private var _pool : StringMap<TiledLevel>;

	public function new(path : String = "assets/data/maps.json") 
	{
		_pool = new StringMap<TiledLevel>();
		var data : Maps;
		data = Json.parse(Assets.getText(path));
		
		for ( s in data.maps)
		{
			//trace(s);
			var l : TiledLevel = new TiledLevel(s);
			_pool.set(s, l);
		}
	}
	
	public function getLevel (n : String) : TiledLevel
	{
		if (_pool.exists(n))
		{
			return _pool.get(n);
		}
		else
		{
			throw "No map with name " + n + " in the MapPool!";
		}
		return null;
	}
	
}

typedef Maps = 
{
	var maps : Array<String>;
}