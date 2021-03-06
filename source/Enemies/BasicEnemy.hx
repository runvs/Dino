package ;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class BasicEnemy extends FlxSprite
{
	public var _sprite : FlxSprite;
	private var _state : PlayState;
	
	public function new(X: Float, Y: Float) 
	{
		super(X, Y);
		_sprite = new FlxSprite(X, Y);
		cameras = [GP.CameraMain];
		_sprite.cameras = [GP.CameraMain];
	}
	
	public function setState (state : PlayState)
	{
		_state = state;
	}
	
	public override function draw()
	{
		_sprite.draw();
	}
	
	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		_sprite.update(elapsed);
		_sprite.x = this.x;
		_sprite.y = this.y;
	}
	
	public function resetCamera()
	{
		this.cameras = [GP.CameraMain];
		this._sprite.cameras = [GP.CameraMain];
	}
}