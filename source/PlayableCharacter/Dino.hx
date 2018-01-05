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
class Dino extends PlayableCharacter
{	
	
	private var _leftGroundTimer : Float = 0;
	private var _jumpbuttonPreholdTimer : Float = -1;
	private var _stepsdirtDeadTime : Float = 0;
	
	public function new() 
	{
		super();
		
		// setting default movement variables
		this.drag.set(GP.DinoMovementDragX, GP.DinoMovementDragY);
		this.maxVelocity.set(GP.DinoMovementMaxVelocityX, GP.DinoMovementMaxVelocityY);
	}
	
	private override function loadSprite ()
	{
		super.loadSprite();
		_sprite.loadGraphic(AssetPaths.dino__png, true, 24, 18);
		_sprite.animation.add("idle", [5,5,5,4,5,5,5,5,5,6,7,8,9], 4);
		_sprite.animation.add("walk", [0, 1, 2, 3], 4);
		_sprite.animation.add("jumpUp", [15, 16, 17, 18], 4, false);
		_sprite.animation.add("jumpDown", [19], 6, true);
		_sprite.animation.play("idle");
		_sprite.setFacingFlip(FlxObject.LEFT, false, false);
		_sprite.setFacingFlip(FlxObject.RIGHT, true, false);
		_sprite.offset.set(8, 4);
		
		this.makeGraphic(8, 13, FlxColor.WHITE, true);
		this.alpha = 0.0;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	
		// triggers once you start touching the ground
		if (_leftGroundTimer != 0 && touchedGround)
		{
			SpawnJumpParticles();
		}
		
		if (touchedGround == false)
		{
			_leftGroundTimer += elapsed;
		}
		else
		{
			_leftGroundTimer = 0;
		}
		_stepsdirtDeadTime -= elapsed;
		_jumpbuttonPreholdTimer -= elapsed;
		
		
		
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
			
			s.velocity.set( vx, - 6 + FlxG.random.float(0, 5));
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
	
	private override function handleInput() 
	{
		super.handleInput();
		
		if (MyInput.JumpButtonJustPressed)
		{
			_jumpbuttonPreholdTimer = GP.DinoMovementJumpPreHoldTimer;
		}
	
		if ( _jumpbuttonPreholdTimer >= 0 && _leftGroundTimer < GP.DinoMoveMentJumpLeftGroundTolerance )
		{
			_sprite.animation.play("jumpUp", true);
			this.velocity.set(velocity.x, GP.DinoMovementJumpStrength);
			if (_stepsdirtDeadTime >= 0)
			{
				_stepsdirtDeadTime = 0.1;
				SpawnStepsDirt();
			}
		}
	}
	
	private override function handleAnimations()
	{
		super.handleAnimations();
		if(Math.abs(velocity.y) > 0.05)	
		{
			if (velocity.y > 0 )
			_sprite.animation.play("jumpDown", false);
		}
	}
}