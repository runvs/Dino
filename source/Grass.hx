package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Grass extends FlxSprite implements IBlowable
{
	
	var timer : Float = -1;
	var blown : Bool = false;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.grass__png, true, 8, 8, false);
		var NumberOfFrames : Int = Math.floor(pixels.height / 8);
		//trace(NumberOfFrames);
		var NumberOfAnims : Int = Math.floor(pixels.width / 8);
		var v : Int = NumberOfAnims * FlxG.random.int(0, NumberOfFrames - 1);
		
		animation.add("idle", [v] , 30);
		animation.add("blow", [for (k in 1...NumberOfAnims) v+k], 6);
		animation.play("idle");
		cameras = [GP.CameraMain];
	}

	public function blow() : Void
	{
		animation.play("blow", true);
		timer = 0.5;
		blown = true;
		
	}
	
	public function getX() : Float 
	{
		return this.x;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (blown)
		{
			timer -= elapsed;
			if (timer <= 0)
			{
				blown = false;
				timer = -1;
				this.animation.play("idle");
			}
		}
	}
	
	public function resetCamera ()
	{
		this.cameras = [GP.CameraMain];
	}
	
}