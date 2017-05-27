package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class EnemyWalkLR extends BasicEnemy
{
	
	public var distance : Float = 0;
	private var _startingPos : Float = 0;
	private var _walkingRight : Bool = true;
	private var _stepsDirt : MyParticleSystem;
	var _stepsTimer:Float = 0;
	
	public function new(X: Float, Y: Float) 
	{
		super(X, Y);
		//this.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		//_sprite.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		
		this.makeGraphic(20, 10, FlxColor.RED);
		_sprite.loadGraphic(AssetPaths.Enemy_FOX__png, true, 20, 16);
		_sprite.animation.add("walk", [0, 1, 2, 3], 7);
		_sprite.animation.play("walk");
		_sprite.setFacingFlip(FlxObject.LEFT, true, false);
		_sprite.setFacingFlip(FlxObject.RIGHT, false, false);
		_startingPos = X;
		
		_stepsDirt = new MyParticleSystem();
		_stepsDirt.cameras = [GP.CameraMain];
		
	}
	
	public override function update(elapsed:Float)
	{
		//trace(this.x);
		super.update(elapsed);
		
		_stepsDirt.update(elapsed);
		_stepsTimer -= elapsed;
		
		if (_stepsTimer <= 0)
		{
			SpawnStepsDirt();
		}
		
		if (_walkingRight)
		{
			_sprite.facing = FlxObject.LEFT;
			this.velocity.x = GP.EnemyWalkLRSpeed;
			if (this.x - _startingPos > distance)
			{
				_walkingRight = false;
				this.x = _startingPos + distance;
			}
		}
		else
		{
			_sprite.facing = FlxObject.RIGHT;
			this.velocity.x = -GP.EnemyWalkLRSpeed;
			if (this.x - _startingPos < 0)
			{
				_walkingRight = true;
				this.x = _startingPos;
			}
		}
		
	}
	
	function SpawnStepsDirt() 
	{		
		_stepsTimer = FlxG.random.floatNormal(0.4, 0.05);
		_stepsDirt.Spawn(4, function(s:FlxSprite) 
		{
			s.alive = true;
			s.alpha = 1;
			var T : Float = 0.45;
			if (_walkingRight)
			{
				s.setPosition(x + FlxG.random.floatNormal(0, 1) , y + 14 );
			}
			else
			{
				s.setPosition(x + this.width * 2.3 / 3.0 + FlxG.random.floatNormal(0, 1) , y + 14 );
			}
			s.velocity.set( FlxG.random.floatNormal(0, 8), - 30+ FlxG.random.floatNormal(0, 5));
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
	
	override public function resetCamera() 
	{
		super.resetCamera();
		_stepsDirt.cameras = [GP.CameraMain];
	}
	
	override public function draw() 
	{
		_stepsDirt.draw();
		super.draw();
	}
	
}