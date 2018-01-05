package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class PlayableCharacter extends FlxSprite
{
	
	// variables for checking if dino is on ground
	public var touchedGround : Bool = false;
	
	// stepsdirt & stepsdirt timer
	var _stepsDirt : MyParticleSystem;
	var _stepsTimer :Float = 0;
	var _jumpParticles : MyParticleSystem;
	
	// picking up stuff
	public var isOnCollectible : Bool = false;
	public var isOnExit : Bool = false;
	public var transport : Bool = false;
	private var _exitBar : HudBar;
	
	// tracer for Cameramovement (with another position)
	public var tracer : FlxSprite;
	public var _sprite : FlxSprite;
	
	public function new() 
	{
		super();
		
		loadSprite();
		this.cameras = [GP.CameraMain];
		_sprite.cameras = [GP.CameraMain];
		
		
		// steps dirt stuff
		_stepsDirt = new MyParticleSystem();
		_stepsDirt.cameras = [GP.CameraMain];
	
		// jumpparticles 
		_jumpParticles = new MyParticleSystem(24);
		_jumpParticles.cameras = [GP.CameraMain];
		
		// exitbar stuff
		_exitBar = new HudBar(0, 0, 8, 4, false);
		_exitBar.scrollFactor.set(1, 1);
		_exitBar._background.color = FlxColor.GRAY;
		_exitBar._background.alpha = 0.4;
		_exitBar.health = 0;
	}
	
	public override function update(elapsed : Float) : Void 
	{
		handleInput();
		handleAnimations();
		super.update(elapsed);
		tracer.setPosition(x * GP.CameraMain.zoom, y * GP.CameraMain.zoom);
		_stepsDirt.update(elapsed);
		_stepsTimer -= elapsed;
		
		_sprite.setPosition(x, y);
		_sprite.facing = this.facing;
		_sprite.update(elapsed);
	
		_exitBar.setBarPosition(x, this.y -2);
		_exitBar.update(elapsed);
		
		_jumpParticles.update(elapsed);
		
		transport = _exitBar.health >= 1;
		if (_exitBar.health <= 0) _exitBar.health = 0;
	}
	
	function handleAnimations() 
	{
		if (Math.abs(velocity.y) < 0.05)
		{
			if (Math.abs(velocity.x) != 0 )
			{
				_sprite.animation.play("walk");
				if (_stepsTimer <= 0 && touchedGround)
				{
					SpawnStepsDirt();
				}
			}
			else 
			{
				_sprite.animation.play("idle", false);
			}
		}
	}
	
	function SpawnStepsDirt() 
	{		
		_stepsTimer = 0.35;
		_stepsDirt.Spawn(4, function(s:FlxSprite) 
		{
			s.alive = true;
			s.alpha = 1;
			var T : Float = 0.45;
			s.setPosition(x + this.width/2 + FlxG.random.floatNormal(0,1) , y + height );
			s.velocity.set( FlxG.random.floatNormal(0, 8), - 40+ FlxG.random.floatNormal(0, 5));
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
	
	function SpawnJumpParticles() 
	{
		_jumpParticles.Spawn(12, function(s:FlxSprite) 
		{
			s.alive = true;
			s.alpha = FlxG.random.float(0.6,0.9);
			s.scale.set(1, 1);
			
			var T : Float = FlxG.random.float(0.75,1.25);
			s.setPosition(x + this.width/2 + FlxG.random.floatNormal(0,this.width/4) , y + height );
			
			var vel : Float = 20;
			var vx : Float = FlxG.random.bool() ? - vel : vel;
			vx *= FlxG.random.float(0.4, 0.9);
			
			s.velocity.set( vx, - 9 + FlxG.random.float(0, 5));
			s.angle = 0;
			s.angularVelocity = -2 * s.velocity.x ;
			s.drag.set(10, 10);
			var sc : Float  = FlxG.random.float(2, 4);
			FlxTween.tween(s.scale, { x: sc, y : sc }, T, { onComplete:function(t) { s.alive = false; }} );
			FlxTween.tween(s, { alpha : 0 }, T);
			
		},
		function (s:FlxSprite)
		{
			if (FlxG.random.bool())
				s.makeGraphic(2, 2, FlxColor.GRAY);
			else
				s.makeGraphic(1, 1, FlxColor.GRAY);
		});
	}
	
	function handleInput()
    {
		var _accelFactor : Float = GP.DinoMovementAccelerationFactor;
		
		acceleration.set();
		
        var vx : Float = MyInput.xVal * _accelFactor;
		var vy : Float = MyInput.yVal * _accelFactor;
		var l : Float = Math.sqrt(vx * vx + vy * vy);

		if (l >= 25)
		{

			if(vx > 0)
			{
				facing = FlxObject.RIGHT;
			}
			else if(vx < 0)
			{
				facing = FlxObject.LEFT;
			}
			// make turning more easy
			if ((velocity.x > 0 && vx < 0) || (velocity.x < 0 && vx > 0))
			{
				this.velocity.x *= 0.5;
			}
		}
		
		if (isOnExit && vy < -0.1)
		{
			_exitBar.health += FlxG.elapsed * 1.5;
		}
		else
		{
			_exitBar.health -= FlxG.elapsed;
		}
		
		var ay : Float = GP.WorldGravity;
		acceleration.set(vx,ay);
    }
	

	
	
	function loadSprite():Void 
	{
		// tracer stuff
		tracer = new FlxSprite();
		tracer.makeGraphic(120, 90, FlxColor.RED);
		tracer.alpha = 0.5;
		tracer.cameras = [GP.CameraOverlay];
		_sprite = new FlxSprite();
	}
	
	public override function draw()
	{
		_stepsDirt.draw();
		_jumpParticles.draw();
		_sprite.draw();
		super.draw();
		_exitBar.draw();
	}
	
	public function teleport(x:Float, y:Float)
	{
		this.setPosition(x, y);
		this.velocity.set();
		this.transport = false;
		isOnExit = false;
		_exitBar.health = 0;
	}
	
	
}