package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
using SpriteFunctions;

/**
 * ...
 * @author 
 */
class CollectibleIcon extends FlxSprite
{
	// must be same as collectible.name
	public var name : String;
	
	private var _collectedIcon : FlxSprite;
	public var collected (default, null) : Bool = false;
	
	
	
	public function new(n : String) 
	{
		super();
		name = n;	
		LoadSprite();
	}
	
	function LoadSprite() 
	{
		Collectible.LoadSprites(this, name);
		this.cameras = [GP.CameraMain];
		// TODO make them grey
		this.scrollFactor.set();
		//this.cameras = [GP.CameraMain];
		//SpriteFunctions.shadeSpriteWithBorder(this);
		this.shadeSpriteWithBorder(FlxColor.fromRGB(150, 150,150), FlxColor.fromRGB(100, 100, 100));
		
		trace("load other");
		_collectedIcon = new FlxSprite();
		Collectible.LoadSprites(_collectedIcon, name);
		_collectedIcon.cameras = [GP.CameraMain];
		_collectedIcon.scrollFactor.set();
		
	}
	
	public override function update(elapsed : Float)
	{
		//trace("update");
		super.update(elapsed);
		
		_collectedIcon.setPosition(x, y);
		//trace("checking " + "has_" + name);
		if (!collected && StoryManager.getBool("has_" + name))
		{
			//trace("!! COLLECTED");
			collected = true;
		}
	}
	
	public override function draw ()
	{
		super.draw();
		
		
		if (collected)
		{
			_collectedIcon.draw();
		}
	}
	
}