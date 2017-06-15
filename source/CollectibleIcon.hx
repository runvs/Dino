package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
	
	private var _collectedIcon : FlashSprite;
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
		this.cameras = [GP.CameraOverlay];
		this.scrollFactor.set();
		this.shadeSpriteWithBorder(FlxColor.fromRGB(150, 150,150), FlxColor.fromRGB(100, 100, 100));
		this.scale.set(2, 2);
		
		//trace("load other");
		_collectedIcon = new FlashSprite();
		Collectible.LoadSprites(_collectedIcon, name);
		_collectedIcon.cameras = [GP.CameraOverlay];
		_collectedIcon.scrollFactor.set();
		_collectedIcon.scale.set(2, 2);
	}
	
	public override function update(elapsed : Float)
	{
		
		super.update(elapsed);
		
		if (!collected && StoryManager.getBool("has_" + name))
		{
			_collectedIcon.scale.set(3.5, 3.5);
			FlxTween.tween(_collectedIcon.scale, { x:2, y:2 }, 0.5 );
			_collectedIcon.Flash(0.5);
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
	
	
	
	override public function setPosition(X:Float = 0, Y:Float = 0):Void 
	{
		super.setPosition(X, Y);
		_collectedIcon.setPosition(X, Y);
	}
}