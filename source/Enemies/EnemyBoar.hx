package;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class EnemyBoar extends BasicEnemy
{
	
	public var distance : Float = 0;
	private var _startingPos : Float = 0;
	
	private var _walkingRight : Bool = true;
	private var _mode : Int = 0;	// 0 = walking left/right
									// 1 = charging
									
	private var _chargeTimer : Float = 0;
	private var _chargeLeft : Bool = true;
	
	public function new(X: Float, Y: Float) 
	{
		super(X, Y);
		this.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		_sprite.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		this.maxVelocity.set( 45, 100);
		_startingPos = X;
	}
	
	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_chargeTimer > 0)
		{
			_chargeTimer -= elapsed;
		}
		
		if (_mode == 0)
		{
			this.acceleration.set();
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
			
			// check if player is in range
			var dinoX : Float = _state.getDinoPosition().x;
			if (Math.abs(dinoX - this.x) < GP.EnemyBoarRange)
			{
				if (_chargeTimer <= 0)
				{
					_mode = 1;
					_chargeTimer = GP.EnemyBoarChargeCoolDown;
					_chargeLeft = (dinoX < this.x);
				}
					
			}
		}
		else if (_mode == 1)
		{
			if (_chargeLeft)
			{
				this.acceleration.x = -GP.EnemyBoarChargeAcceleration;
			}
			else
			{
				this.acceleration.x = GP.EnemyBoarChargeAcceleration;
			}
			
			//  get out of charge mode if we have reached the end of the enemies walking line.
			if (this.x - _startingPos > distance)
			{
				_mode = 0;
				this.x = distance + _startingPos;
				
			}
			if (this.x - _startingPos < 0  )
			{
				_mode = 0;
				this.x = _startingPos;
			}			
		}
	}
}