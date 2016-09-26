package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class GatherState extends PlayState
{

	
	private var _collectiblesRequired : Array<CollectibleIcon>;
	private var _collectiblesList : Array<String>;
	
	public function new(n:String, a : String) 
	{
		super(n, a);
		
	}

	public override function create() : Void
	{
		super.create();
		
		createCollectibleListIntern();
	}
	
	public function createCollectibleList(c : Array<String> )
	{
		_collectiblesList = c;
		
	}
	
	private function createCollectibleListIntern ()
	{
		_collectiblesRequired = new Array<CollectibleIcon>();
		for (i in 0 ... _collectiblesList.length)
		{
			var s : CollectibleIcon  = new CollectibleIcon(_collectiblesList[i]);
			s.setPosition(4 + i * 20, 4);
			//s.alpha = 0.3;
			_collectiblesRequired.push(s);
		}
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
		for (c in _level.collectibles)
		{
			c.update(elapsed);
		}
		CheckCollectibles();
		for (i in 0..._collectiblesRequired.length)
		{
			var s : CollectibleIcon = _collectiblesRequired[i];
			s.update(elapsed);
		}
		
	}
	
	override public function internalDraw() 
	{
		for (c in _level.collectibles)
		{
			c.draw();
		}
				//_collectiblesRequired.draw();
		for (i in 0..._collectiblesRequired.length)
		{
			var s : CollectibleIcon = _collectiblesRequired[i];
			s.draw();
		}
		
		super.internalDraw();
		

	}
}