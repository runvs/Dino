package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class SpeechBubble extends FlxSprite
{
	
	private var parent : FlxSprite;

	private var timer : Float;
	
	private var icon : FlxSprite;
	
	public function new(p: FlxSprite, i : String, d : Float) 
	{
		super();
		parent = p;
		timer = d;
		this.loadGraphic(AssetPaths.speechbubble__png, false, 16, 16);
		this.offset.set(0, 16);
		this.cameras = [GP.CameraMain];
		
		icon = new FlxSprite();
		icon.cameras = [GP.CameraMain];
		if (i == "heart")
		{
			icon.loadGraphic(AssetPaths.heart__png, false, 16, 16);
			icon.offset.set(0, 16);
		}
		
	}
	
	public override function update (elapsed : Float) : Void 
	{
		super.update(elapsed);
		this.setPosition(parent.x + parent.width, parent.y);
		icon.setPosition(x, y);
		timer -= elapsed;
		if (timer <= 0)
		{
			this.alpha = 0;
			icon.alpha = 0;
			this.alive = false;
			
		}
	}
	
	public override function draw () : Void 
	{
		super.draw();
		icon.draw();
	}
	
	
}