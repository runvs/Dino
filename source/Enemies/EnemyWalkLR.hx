package;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class EnemyWalkLR extends BasicEnemy
{
	
	public var distance : Float = 0;
	private var _startingPos : Float = 0;
	private var _walkingRight : Bool = true;
	
	public function new(X: Float, Y: Float) 
	{
		super(X, Y);
		this.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		_sprite.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		
		_startingPos = X;
	}
	
	public override function update(elapsed:Float)
	{
		//trace(this.x);
		super.update(elapsed);
		
		if (_walkingRight)
		{
			this.velocity.x = GP.EnemyWalkLRSpeed;
			if (this.x - _startingPos > distance)
			{
				_walkingRight = false;
				this.x = _startingPos + distance;
			}
		}
		else
		{
			this.velocity.x = -GP.EnemyWalkLRSpeed;
			if (this.x - _startingPos < 0)
			{
				_walkingRight = true;
				this.x = _startingPos;
			}
		}
		
	}
	
}