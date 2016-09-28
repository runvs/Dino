package;
import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class DinoBag extends PlayableCharacter
{

	public function new() 
	{
		super();
		
		// setting default movement variables
		this.drag.set(GP.DinoMovementDragX * 1.5, GP.DinoMovementDragY);
		this.maxVelocity.set(GP.DinoMovementMaxVelocityX, GP.DinoMovementMaxVelocityY);
		
		
	}
	
	private override function loadSprite ()
	{
		super.loadSprite();
		this.loadGraphic(AssetPaths.dino_bag__png, true, 24, 18);
		this.animation.add("idle", [5,5,5,4,5,5,5,5,5,6,7,8,9], 4);
		this.animation.add("walk", [0, 1, 2, 3], 4);
		this.animation.add("sleep", [10, 11, 12, 13], 4, true);
		this.animation.add("wakeup", [14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37], 5, false);
		this.animation.play("idle");
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
	}
	
}