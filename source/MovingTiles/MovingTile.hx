package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class MovingTile extends FlxSprite
{
	public var _sprite : FlxSprite;
	private var _following : Bool = true;
	
	private var _dino : PlayableCharacter = null;
	private var _touched : Bool = false;
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		_sprite = new FlxSprite();
		this.immovable = true;
		_sprite.immovable = true;
		resetCamera();
	}
	
	override public function loadGraphic(Graphic:FlxGraphicAsset, Animated:Bool = false, Width:Int = 0, Height:Int = 0, Unique:Bool = false, ?Key:String):FlxSprite 
	{
		return _sprite.loadGraphic(Graphic, Animated, Width, Height, Unique, Key);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	
		if (_following)
		{
			SpriteFollows();
		}
	}
	
	override public function draw():Void 
	{
		
		_sprite.draw();
		super.draw();
	}
	
	public function setDino (di:PlayableCharacter)
	{
		_dino = di;
	}
	
	public function touchMe ( )
	{
		_touched = true;
	}
	
	
	public function resetMe()
	{
		this.alive = true;
	}
	
	public function resetCamera()
	{
		_sprite.cameras = [GP.CameraMain];
	}
	
	function SpriteFollows():Void 
	{
		_sprite.setPosition(x,y);
	}
}