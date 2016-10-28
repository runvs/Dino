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
	
	
	private override function handleInput() 
	{
		super.handleInput();
		if (_jumpTimer <= 0)
		{
			if (MyInput.JumpButtonJustPressed && _isOnGround)
			{
				_jumpTimer = 0.25;
				_sprite.animation.play("jumpUp", true);
				this.velocity.set(velocity.x, GP.DinoMovementJumpStrength);
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