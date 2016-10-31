package;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class HurtingSpriteTopFalling extends HurtingSprite
{

	private var _wiggleTimer : FlxTimer;
	private var _wiggleActiveTimer : Float = 0;
	private var _falling : Bool = false;
	private var _FallingTimer : FlxTimer;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		LoadHurtingGraphic(TiledLevel.TileIDHurtingTopFalling);
		_wiggleTimer = new FlxTimer();
		_FallingTimer = new FlxTimer();
		_wiggleTimer.start(GP.LevelHurtingFallingWiggleDeadTime, doWiggle, 0);
	}
	
	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		updateWiggle(elapsed);
		checkPlayerPosForWiggle();
	}
	
	function startFalling() 
	{
		if (!_falling)
		{
			_falling = true;
			_FallingTimer.start(GP.LevelHurtingFallingDelay, function (t) { velocity.y = GP.LevelHurtingFallingVelocity; } );
		}
	}
	
	
	
	private function doWiggle(t) : Void
	{
		wiggle();
	}
	
	function updateWiggle(elapsed : Float):Void 
	{
		if (_wiggleActiveTimer > 0 || _falling)
		{
			_wiggleActiveTimer -= elapsed;
			offset.set(FlxG.random.floatNormal(0, 1), 0);
		}
		else
		{
			offset.set();
		}
	}
	
	function checkPlayerPosForWiggle():Void 
	{
		if (!_falling)
		{
			if (_playerPosition.y >= y + 8 && _playerPosition.y < y + 100)
			{
				if (_playerPosition.x + GP.WorldTileSizeInPixel * GP.LevelHurtingFallingXMarginFactor >= x && _playerPosition.x <= x + GP.WorldTileSizeInPixel * GP.LevelHurtingFallingXMarginFactor)
				{
					wiggle();
					startFalling();
				}
			}
		}
	
	}
	
	public function wiggle() 
	{
		_wiggleActiveTimer = 0.35;
	}
	
	
	
}