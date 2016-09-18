package;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class GatherState extends PlayState
{

	public function new(n:String) 
	{
		super(n);
	}
	
	public override function create() : Void
	{
		super.create();
		
	}
	
	public function CheckCollectibles() : Void 
	{
		for (c in _level.collectibles)
		{
			if (!c.checkConditions()) continue;
			if (FlxG.overlap(d, c))
			{
				//c.
			}
		}
	}
	
}