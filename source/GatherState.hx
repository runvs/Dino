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
		d.isOnCollectible = false;
		for (c in _level.collectibles)
		{
			if (!c.checkConditions()) continue;
			if (FlxG.overlap(d, c))
			{
				d.isOnCollectible = true;
				if (MyInput.AttackButtonJustPressed)
				{
					c.collectMe();
				}
			}
		}
		
		for (i in 0..._level.collectibles.length)
		{
			var c : Collectible = _level.collectibles[i];
			if (!c.alive)
			{
				_level.collectibles.remove(c);
			}
			if (i == _level.collectibles.length - 1) break;
		}
		
		
	}
	
	public override function internalUpdate(elapsed:Float)
	{
		super.internalUpdate(elapsed);
		
		CheckCollectibles();
	}
	
	override public function internalDraw() 
	{
		for (c in _level.collectibles)
		{
			c.draw();
		}
		
		super.internalDraw();
	}
}