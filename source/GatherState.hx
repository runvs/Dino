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
	
	private var _collectiblesList : Array<String>;
	private var _indicator : TargetIndicator;
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
		_indicator = new TargetIndicator(this.d);
		trace("gatherstate create mid");
		SetTarget();
		trace("create done");
	}
	
	public function createCollectibleList(c : Array<String> )
	{
		_collectiblesList = c;
		
	}

	public override function LoadLevel(l : String)
	{
		super.LoadLevel(l);
		SetTarget();
		trace("loadlevel done");
	}
	
	private function createCollectibleListIntern ()
	{
		_collectiblesIcons = new Array<CollectibleIcon>();
		for (i in 0 ... _collectiblesList.length)
		{
			var s : CollectibleIcon  = new CollectibleIcon(_collectiblesList[i]);
			s.setPosition(4 + i * 20, 4);
			//s.alpha = 0.3;
			_collectiblesIcons.push(s);
		}
	}
	
	private function SetTarget():Void 
	{
		if (_indicator == null) return;
		trace("settarget " + _gatherID);
		if (_gatherID >= 0 && _gatherID < _collectiblesList.length)
		{
			var cName : String = _collectiblesList[_gatherID];
			trace ("Name: " + cName);
			var condObject : ConditionalObject = _level.getConditionalObjectByName(cName);
			_indicator.SetTarget(condObject);
			
			if (condObject != null)
			{
				trace("found condObject");
				if (Std.is(condObject, Collectible))
				{
					var coll : Collectible = cast condObject;
					trace("checking " + coll._storyManagerID);
					if (StoryManager.getBool(coll._storyManagerID))
					{
						trace("increase gatherID");
						_gatherID += 1;
						SetTarget();
					}
				}
			}
		}
		else
		{
			_indicator.SetTarget(null);
		}
		
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
					c.collectMe();
					SetTarget();
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
		
		CheckCollectibles();
		ClearCollectibles();	
		UpdateIcons();
		
		
		_indicator.update(elapsed);
	}
	
	override public function internalDraw() 
	{
		for (c in _level.collectibles)
		{
			c.draw();
		}
				//_collectiblesRequired.draw();
		for (i in 0..._collectiblesIcons.length)
		{
			var s : CollectibleIcon = _collectiblesIcons[i];
			s.draw();
		}
		
		super.internalDraw();
		//d.tracer.draw();
		_indicator.draw();

	}
}