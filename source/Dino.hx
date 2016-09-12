package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Dino extends FlxSprite
{
	var _attackCooldown : Float;
	
	var _jumpTimer : Float;
	var _isOnGround : Bool;
	
	public function new() 
	{
		super();
		
		this.loadGraphic(AssetPaths.dino__png, true, 24, 18);
		this.animation.add("idle", [5,5,5,4,5,5,5,5,5,6,7,8,9], 4);
		this.animation.add("walk", [0, 1, 2, 3], 4);
		this.animation.add("jumpUp", [15, 16, 17], 4, false);
		this.animation.add("jumpDown", [18, 19, 20], 6, false);
		this.animation.play("idle");
		
		this.cameras = [GP.CameraMain];
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
		_attackCooldown = 0;
		_jumpTimer = 0;
		this.drag.set(GP.DinoMovementDragX, GP.DinoMovementDragY);
		this.maxVelocity.set(GP.DinoMovementMaxVelocityX, GP.DinoMovementMaxVelocityY);
	} 
	
	public override function update(elapsed : Float) : Void 
	{
		_isOnGround = (velocity.y == 0);
		_attackCooldown -= elapsed;
		_jumpTimer -= elapsed;
		handleInput();
		handleAnimations();
		super.update(elapsed);
		
		
	}
	
	function handleAnimations() 
	{
		//trace(velocity.x + " " + velocity.y);
		if (Math.abs(velocity.y) < 0.05)
		{
			if (Math.abs(velocity.x) != 0 )
			{
				this.animation.play("walk");
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
}