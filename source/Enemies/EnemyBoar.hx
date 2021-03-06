package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
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
	private var _chargeRight : Bool = true;
	
	private var _stepsDirt : MyParticleSystem;
	var _stepsTimer:Float = 0;
	
	
	private static var _collideSparkz : MyParticleSystem;
	private var _sparkRight : Bool = false;
	private var _sparkLeft : Bool = false;
	
	
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
		
		_stepsDirt = new MyParticleSystem();
		_stepsDirt.cameras = [GP.CameraMain];
		
		_collideSparkz = new MyParticleSystem();
		_collideSparkz.cameras = [GP.CameraMain];
	}
	
	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		
		updateStepsDirt(elapsed);
		_collideSparkz.update(elapsed);
		
		//trace(_collideSparkz.length);
		
		if (_chargeTimer > 0)
		{
			_chargeTimer -= elapsed;
		}
		if (_mode == 0)
		{
			this.maxVelocity.set( 55, 100);
			doBoarPatrol(elapsed);
			
			// check if player is in range
			if (_state == null) throw "ERROD: State null in EnemyBoar";
			var dinoY : Float = _state.getDinoPosition().y;
			var dy : Float = dinoY - this.y;
			if (Math.abs(dy) < 3 * GP.WorldTileSizeInPixel)
			{
				var dinoX : Float = _state.getDinoPosition().x;
				if (Math.abs(dinoX - this.x) < GP.EnemyBoarRange)
				{
					SwitchToChargeMode(dinoX);
				}
			}
		}
		else if (_mode == 1)
		{
			this.maxVelocity.set( 115, 100);
			var ba = GP.EnemyBoarChargeAcceleration;
			this.acceleration.x = (_chargeRight ? ba : - ba);
			
			//  get out of charge mode if we have reached the end of the enemies walking line.
			if (this.x - _startingPos > distance)
			{
				if (_sparkRight)
					SpawnSpakz();
				_mode = 0;
				this.x = distance + _startingPos;
				_sprite.animation.play("walk", true);
			
			}
			if (this.x - _startingPos < 0  )
			{
				if (_sparkLeft)
					SpawnSpakz();
				_mode = 0;
				this.x = _startingPos;
				_sprite.animation.play("walk", true);
			}			
		}
	}
	
	
	override public function draw() 
	{
		//trace("draw");
		_stepsDirt.draw();
		super.draw();
		_collideSparkz.draw();
	}
	
	function SpawnSpakz() 
	{
		//trace("sparkz");
		_collideSparkz.Spawn(20, function(s:FlxSprite) 
		{
			s.alive = true;
			s.alpha = FlxG.random.float(0.5,0.8);
			
			var T : Float = FlxG.random.float(0.25,0.35);
			var left : Bool = velocity.x < 0;
			if (left)
				s.setPosition(x + FlxG.random.floatNormal(0,this.width/8) , y + FlxG.random.float(0,height) );
			else
				s.setPosition(x + this.width + FlxG.random.floatNormal(0,this.width/8) , y + FlxG.random.float(0,height) );
			
			s.velocity.set( FlxG.random.floatNormal(0,10), - 18+ FlxG.random.floatNormal(((_mode != 1)? 0 : -15), 5));
			s.acceleration.set(0, 125);
			FlxTween.tween(s, { alpha : 0 }, T / 4, { startDelay:T / 4 * 3, onComplete : function (t) { s.alive = false; }} );
		},
		function (s:FlxSprite)
		{
			s.makeGraphic(1, 1, FlxColor.fromRGB(180,164,92));
		});
	}
	
	
	
	function SpawnStepsDirt() 
	{		
		_stepsTimer = FlxG.random.floatNormal(0.4, 0.05);
		_stepsDirt.Spawn(4, function(s:FlxSprite) 
		{
			s.alive = true;
			s.alpha = 1;
			var T : Float = 0.45;
			if (_mode != 1)
			{
				if (_walkingRight)
				{
					s.setPosition(x + FlxG.random.floatNormal(0, 1) , y + 14 );
				}
				else
				{
					s.setPosition(x + this.width * 2.3 / 3.0 + FlxG.random.floatNormal(0, 1) , y + 14 );
				}
			}
			else
			{
				if (_chargeRight)
				{
					s.setPosition(x + FlxG.random.floatNormal(0, 1) , y + 14 );
				}
				else
				{
					s.setPosition(x + this.width * 2.3 / 3.0 + FlxG.random.floatNormal(0, 1) , y + 14 );
				}

			}
			
			s.velocity.set( FlxG.random.floatNormal(0, 8), - 30+ FlxG.random.floatNormal(((_mode != 1)? 0 : -15), 5));
			s.acceleration.set(0, 175);
			var t : FlxTimer = new FlxTimer();
			t.start(T, function (t) { s.alive = false; s.alpha = 0; } );
		},
		function (s:FlxSprite)
		{
			if (FlxG.random.bool())
				s.makeGraphic(1, 1, FlxColor.fromRGB(54, 38, 22));
			else
				s.makeGraphic(1, 1, FlxColor.fromRGB(45,74,44));
		});
	}
	
	function updateStepsDirt(elapsed):Void 
	{
		_stepsDirt.update(elapsed);
		_stepsTimer -= elapsed;
		if (_stepsTimer <= 0)
		{
			SpawnStepsDirt();
		}
	}
	
	function doBoarPatrol(elapsed):Void 
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
	}
	
	function SwitchToChargeMode(dinoX:Float):Void 
	{
		if (_chargeTimer <= 0)
		{
			_mode = 1;
			_chargeTimer = GP.EnemyBoarChargeCoolDown;
			_chargeRight = !(dinoX < this.x);
			_sprite.facing = _chargeRight ? FlxObject.RIGHT: FlxObject.LEFT;
			_sprite.animation.play("attention", true);
			var t : FlxTimer = new FlxTimer();
			t.start(0.5, function(t) 
			{ 
				_sprite.animation.play("charge", true); 
				this.velocity.x += _chargeRight? 20 : -20;
			} );
			//_sprite.animation.play
		}
	}
	
	public function setStart(s:Float)
	{
		this.x += s * GP.WorldTileSizeInPixel;
	}
	
	override public function resetCamera() 
	{
		super.resetCamera();
		_stepsDirt.cameras = [GP.CameraMain];
		_collideSparkz.cameras = [GP.CameraMain];
	}

	
	public function setLeftRightSpark(l : Bool, r : Bool)
	{
		trace(l +  " " + r);
		_sparkLeft = l;
		_sparkRight = r;
		
	}
	
}