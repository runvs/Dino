package;
import haxe.Json;
import haxe.ds.StringMap;
import openfl.Assets;
import sys.FileSystem;
/**
 * ...
 * @author 
 */
class MapPool
{
	
	private var _pool : StringMap<TiledLevel>;

	public function new() 
	{
		_pool = new StringMap<TiledLevel>();
		
		var list : Array<String> = FileList.getFileList("assets/data/", "tmx");
		for ( s in list)
		{
			trace(s);
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