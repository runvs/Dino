package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class CutSceneActor extends FlxSprite
{

	public var name (default, null) : String ;
	public function new(n: String) 
	{
		name = n;
		super();
		
		LoadActor();
	}
	
	function LoadActor() 
	{
		switch (name)
		{
			case "dino":
				trace("load dino");
				this.loadGraphic(AssetPaths.dino__png, true, 24, 18);
				this.animation.add("idle", [0], 40);
				this.animation.add("walk", [ 1, 2, 3, 0], 4);
				this.animation.add("jumpUp", [14, 15, 16], 4, false);
				this.animation.add("jumpDown", [18, 19], 4, false);
				this.animation.play("idle");
				setFacingFlip(FlxObject.LEFT, false, false);
				setFacingFlip(FlxObject.RIGHT, true, false);

			default:
				
		}
	}
	
	public override function update (elapsed : Float ) : Void 
	{
		super.update(elapsed);
		
		if(velocity.x > 0)
		{
			facing = FlxObject.RIGHT;
		}
		else if(velocity.x < 0)
		{
			facing = FlxObject.LEFT;
		}

	}
}