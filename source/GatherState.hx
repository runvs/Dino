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

	// Collectibles are shown in the hud. this array is a list of those icons
	private var _collectiblesIcons : Array<CollectibleIcon>;
	
	private var _inventoryBackground : FlxSprite;
	
	private var _collectiblesList : Array<String>;
	private var _gatherID : Int;
	
	public function new(n:String, a : String) 
	{
		super(n, a);
		
	}

	public override function create() : Void
	{
		trace("gatherstate create");
		super.create();
		_gatherID = 0;
		
		
		
		
		createCollectibleListIntern();
		
		trace("gatherstate create mid");
		trace("create done");
	}
	
	public function createCollectibleList(c : Array<String> )
	{
		_collectiblesList = c;
		
	}

	public override function LoadLevel(l : String)
	{
		super.LoadLevel(l);
		//trace("loadlevel done");
	}
	
	private function createCollectibleListIntern ()
	{
		_collectiblesIcons = new Array<CollectibleIcon>();
		var N : Int = _collectiblesList.length;
		
		var nhalf : Float = N / 2.0;
		var xleft : Float = FlxG.width / 2.0 - 20 * nhalf * 4;
		
		for (i in 0 ... N)
		{
			var s : CollectibleIcon  = new CollectibleIcon(_collectiblesList[i]);
			s.setPosition(xleft + i * 22 * 4,  FlxG.height  - 16 *3);
			//s.alpha = 0.3;
			_collectiblesIcons.push(s);
		}
		_inventoryBackground = new FlxSprite();
		_inventoryBackground.makeGraphic(N * 22 + 4, 20, FlxColor.fromRGB(102,57,49));
		_inventoryBackground.cameras = [GP.CameraMain];
		_inventoryBackground.scrollFactor.set(0, 0);
		
		_inventoryBackground.setPosition(FlxG.width/2/GP.CameraMain.zoom - 22 * nhalf, FlxG.height / GP.CameraMain.zoom - 16);
		
	}
	
	function ClearCollectibles():Void 
	{
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
	
	function UpdateIcons():Void 
	{
		for (i in 0..._collectiblesIcons.length)
		{
			var s : CollectibleIcon = _collectiblesIcons[i];
			s.update(FlxG.elapsed);
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
					c.collectMe(this);
				}
			}
		}
	}
	
	public override function internalUpdate(elapsed:Float)
	{
		super.internalUpdate(elapsed);
		
		for (c in _level.collectibles)
		{
			c.update(elapsed);
		}
		
		_inventoryBackground.update(elapsed);
		
		CheckCollectibles();
		ClearCollectibles();	
		UpdateIcons();
	}
	
	override public function internalDraw() 
	{
		
		for (c in _level.collectibles)
		{
			c.draw();
		}
		
		
		
		super.internalDraw();
		
		
		//d.tracer.draw();
		

	}
	
		public override function internalDrawTop() : Void
	{
	_inventoryBackground.draw();
		//_collectiblesRequired.draw();
		for (i in 0..._collectiblesIcons.length)
		{
			var s : CollectibleIcon = _collectiblesIcons[i];
			s.draw();
			
		}
	}
}