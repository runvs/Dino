package;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

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
									// 2 = attention
									
	private var _chargeTimer : Float = 0;
	private var _chargeLeft : Bool = true;
	
	public function new(X: Float, Y: Float) 
	{
		super(X, Y);
		this.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		//_sprite.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizleInPixel, FlxColor.RED);
		_sprite.loadGraphic(AssetPaths.Enemy_Boar__png, true, 24, 18);
		_sprite.animation.add("walk", [0, 1, 2, 3, 4], 10);
		_sprite.animation.add("attention", [5,6,7,8,9], 10, false);
		_sprite.animation.add("charge", [10, 11, 12, 13, 14], 18);
		_sprite.setFacingFlip(FlxObject.LEFT, true, false);
		_sprite.setFacingFlip(FlxObject.RIGHT, false, false);
		this._sprite.animation.play("walk");
		this._sprite.offset.set(0, 2);
		this.maxVelocity.set( 55, 100);
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
				_sprite.facing = FlxObject.RIGHT;
				this.velocity.x = GP.EnemyWalkLRSpeed;
				if (this.x - _startingPos > distance)
				{
					_walkingRight = false;
					this.x = _startingPos + distance;
				}
			}
			else
			{
				_sprite.facing = FlxObject.LEFT;
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
					_sprite.facing = _chargeLeft ? FlxObject.LEFT : FlxObject.RIGHT;
					_sprite.animation.play("attention", true);
					var t : FlxTimer = new FlxTimer();
					t.start(0.5, function(t) 
					{ 
						_sprite.animation.play("charge", true); 
						this.velocity.x += _chargeLeft? -10 : 10;
					} );
					//_sprite.animation.play
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
				_sprite.animation.play("walk", true);
			}
			if (this.x - _startingPos < 0  )
			{
				_mode = 0;
				this.x = _startingPos;
				_sprite.animation.play("walk", true);
			}			
		}
	}
}