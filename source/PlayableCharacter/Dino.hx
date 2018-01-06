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
	
	private var _jumpbuttonPressedTimer : Float = 0;
	private var _myElapsed : Float = 0;
	
	
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
	
		_myElapsed = elapsed;
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
	
	
	
	private override function handleInput() 
	{
		super.handleInput();
		
		if (MyInput.JumpButtonJustPressed)
		{
			_jumpbuttonPreholdTimer = GP.DinoMovementJumpPreHoldTimer;
			
		}
		
		
		
		if (MyInput.JumpButtonPressed)
		{
			_jumpbuttonPressedTimer += _myElapsed;
			if (_jumpbuttonPressedTimer >= GP.DinoMovementJumpPostHoldTimer)
			{
				_jumpbuttonPressedTimer = GP.DinoMovementJumpPostHoldTimer;
			}
		}
		else
		{
			_jumpbuttonPressedTimer = 0;
		}
		
		if (MyInput.JumpButtonJustPressed && _leftGroundTimer <= 0.01)
		{
			SpawnJumpParticles();
		}
	
		if ( _jumpbuttonPreholdTimer >= 0 && _leftGroundTimer < GP.DinoMoveMentJumpLeftGroundTolerance )
		{
			_sprite.animation.play("jumpUp", true);
			
			this.velocity.set(velocity.x,  GP.DinoMovementJumpStrength);
			if (_stepsdirtDeadTime >= 0)
			{
				_stepsdirtDeadTime = 0.1;
				SpawnStepsDirt();
			}
		}
		
		if (_jumpbuttonPressedTimer> 0 && _jumpbuttonPressedTimer < GP.DinoMovementJumpPostHoldTimer && _leftGroundTimer <= GP.DinoMovementJumpPostHoldTimer)
		{
			this.velocity.set(velocity.x,  velocity.y + 0.8 *GP.DinoMovementJumpStrength * _jumpbuttonPressedTimer/GP.DinoMovementJumpPostHoldTimer);
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