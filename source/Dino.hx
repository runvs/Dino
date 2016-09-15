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
class Dino extends FlxSprite
{
	var _attackCooldown : Float;
	
	var _jumpTimer : Float;
	var _isOnGround : Bool;
	public var touchedGround : Bool = false;
	var _isOnGroundTimer  : Float = 0;
	
	var _stepsDirt : MyParticleSystem;
	var _stepsTimer :Float = 0;
	
	public var isOnExit : Bool = false;
	private var exitBar : HudBar;
	public var transport : Bool = false;
	public var overlay : FlxSprite;
	
	public function new() 
	{
		super();
		
		this.loadGraphic(AssetPaths.dino__png, true, 24, 18);
		this.animation.add("idle", [5,5,5,4,5,5,5,5,5,6,7,8,9], 4);
		this.animation.add("walk", [0, 1, 2, 3], 4);
		this.animation.add("jumpUp", [15, 16, 17, 18], 4, false);
		this.animation.add("jumpDown", [19], 6, true);
		this.animation.play("idle");
		
		this.cameras = [GP.CameraMain];
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
		_attackCooldown = 0;
		_jumpTimer = 0;
		this.drag.set(GP.DinoMovementDragX, GP.DinoMovementDragY);
		this.maxVelocity.set(GP.DinoMovementMaxVelocityX, GP.DinoMovementMaxVelocityY);
		
		_stepsDirt = new MyParticleSystem();
		_stepsDirt.cameras = [GP.CameraMain];
		exitBar = new HudBar(0, 0, 16, 4, false);
		exitBar.cameras = [GP.CameraMain];
		exitBar.scrollFactor.set(1, 1);
		exitBar._background.color = FlxColor.TRANSPARENT;
		exitBar.health = 0;
		
		overlay = new FlxSprite();
		//doverlay.makeGraphic(120, 90, FlxColor.TRANSPARENT);
		overlay.makeGraphic(120, 90, FlxColor.RED);
		overlay.alpha = 0.5;
		overlay.cameras = [GP.CameraOverlay];
	} 
	
	public override function update(elapsed : Float) : Void 
	{
		_isOnGround = (velocity.y == 0);
		if ( _isOnGround) _isOnGroundTimer += elapsed;
		else _isOnGroundTimer = 0;
		_attackCooldown -= elapsed;
		_jumpTimer -= elapsed;
		handleInput();
		handleAnimations();
		super.update(elapsed);
		overlay.setPosition(x * GP.CameraMain.zoom, y * GP.CameraMain.zoom);
		_stepsDirt.update(elapsed);
		_stepsTimer -= elapsed;
		exitBar.setPosition(x, y - 2);
		exitBar.update(elapsed);
		transport = exitBar.health >= 1;
		if (exitBar.health <= 0) exitBar.health = 0;
	}
	
	function handleAnimations() 
	{
		//trace(velocity.x + " " + velocity.y);
		if (Math.abs(velocity.y) < 0.05)
		{
			if (Math.abs(velocity.x) != 0 )
			{
				this.animation.play("walk");
				if (_stepsTimer <= 0 && touchedGround)
				{
					SpawnStepsDirt();
				}
			}
			else 
			{
				this.animation.play("idle", false);
			}
		}
		else
		{
			if (velocity.y > 0)
			this.animation.play("jumpDown", false);
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
			//s.alpha = FlxG.random.float(0.125, 0.35);
			//FlxTween.tween(s, { alpha:0 }, T, { onComplete: function(t:FlxTween) : Void { s.alive = false; } } );
			s.velocity.set( FlxG.random.floatNormal(0, 4), - 40+ FlxG.random.floatNormal(0, 1));
			s.acceleration.set(0, 175);
			var t : FlxTimer = new FlxTimer();
			t.start(T, function (t) { s.alive = false; s.alpha = 0; } );
		},
		function (s:FlxSprite)
		{
			if (FlxG.random.bool())
			{
				s.makeGraphic(1, 1, FlxColor.fromRGB(54, 38, 22));
			}
			else
			{
				s.makeGraphic(1, 1, FlxColor.fromRGB(45,74,44));
			}
		});
	}
	
	function handleInput()
    {
		var _accelFactor : Float = GP.DinoMovementAccelerationFactor;
		
		acceleration.set();
		
        var vx : Float = MyInput.xVal * _accelFactor;
		var vy : Float = MyInput.yVal * _accelFactor;
		var l : Float = Math.sqrt(vx * vx + vy * vy);

		//trace(vx);
		
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
			exitBar.health += FlxG.elapsed * 1;
		}
		else
		{
			exitBar.health -= FlxG.elapsed;
		}
	
		var ay : Float = GP.WorldGravity;
		acceleration.set(vx,ay);
		
		if (MyInput.AttackButtonJustPressed ) 
			attack();
			
		if (_jumpTimer <= 0)
		{
			if (MyInput.JumpButtonJustPressed && _isOnGround)
			{
				_jumpTimer = 0.25;
				this.animation.play("jumpUp", true);
				this.velocity.set(velocity.x, GP.DinoMovementJumpStrength);
				SpawnStepsDirt();
			}
		}
    }
	
	function attack() 
	{
		if(_attackCooldown <= 0.0)
		{
			trace("attack");
			_attackCooldown = 0.5;
		}
	}
	
	public override function draw()
	{
		_stepsDirt.draw();
		super.draw();
		//exitBar.draw();
	}
	
	public function teleport(x:Float, y:Float)
	{
		this.setPosition(x, y);
		this.velocity.set();
		this.transport = false;
		isOnExit = false;
		exitBar.health = 0;
		
	}
}