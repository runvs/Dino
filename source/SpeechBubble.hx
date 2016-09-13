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
		
		
		LoadIcon(i);
		
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
	
	private function LoadIcon(i : String):Void 
	{
		icon = new FlxSprite();
		icon.cameras = [GP.CameraMain];
		if ( i == "heart")
		{
				icon.loadGraphic(AssetPaths.icon_heart__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else if (i == "house")
		{
				icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else if (i == "fish")
		{
				icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else if (i == "apple")
		{
				icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else if (i == "flower")
		{
				icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else if (i == "egg")
		{
				icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else if (i == "excamation")
		{
				icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else if (i == "question")
		{
				icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
				icon.offset.set(0, 16);
		}
		else
		{
			throw "Speechbubble of type: "  + i + " no known!";
		}
	}
	
	
}