package;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class MovingTileBreak extends MovingTile
{
	private var breaking : Bool = false;
	private var breakTimer : Float = 0.5;
	private var _wiggle : Bool = false;
	private var _wiggleTimer : Float = 0;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		this.makeGraphic(GP.WorldTileSizeInPixel, Std.int(GP.WorldTileSizeInPixel/2), FlxColor.fromRGB(255, 0, 0, 100));
		_sprite.makeGraphic(GP.WorldTileSizeInPixel*GP.CameraMain.zoom, Std.int(GP.WorldTileSizeInPixel /2 * GP.CameraMain.zoom), FlxColor.fromRGB(255, 255, 255, 255));
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		_sprite.update(elapsed);

		if (_wiggle)
		{
			_wiggleTimer -= elapsed;
			if (_wiggleTimer <= 0)
			{
				_wiggleTimer = 0.1;
				_sprite.offset.set(FlxG.random.floatNormal(0, 1), FlxG.random.floatNormal(0, 1));
			}
		}
		
		if (!breaking)
		{
			if (_dino != null)
			{
				if (_touched)
				{
					breaking = true;
					_wiggle = true;
					FlxTween.color(_sprite, 0.5, FlxColor.WHITE, FlxColor.RED);
				}
			}
		}
		else
		{
			breakTimer -= elapsed;
			if (breakTimer + elapsed > 0 && breakTimer < 0)	// we have crossed the zero
			{
				_following = false;
				_sprite.acceleration.set(0, GP.WorldGravity);
				_sprite.velocity.set(0, 20);
				this.setPosition( -5000000, -5000000);
				this.alive = false;
			}
			if (breakTimer <= -10)
			{
				resetMe();
			}
		}
	}
	
	override public function resetMe() 
	{
		super.resetMe();
		_following = true;
		breakTimer = 0.5;
		breaking = false;
		_sprite.velocity.set(0, 0);
		_sprite.acceleration.set(0, 0);
		_wiggle = false;
		_sprite.offset.set();
		_sprite.color = FlxColor.WHITE;
	}
	
	override public function resetCamera() 
	{
		//super.resetCamera();
		_sprite.cameras = [GP.CameraOverlay];
	}
	override function SpriteFollows():Void 
	{
		if (_following)
		{
			_sprite.setPosition(x * GP.CameraMain.zoom, y * GP.CameraMain.zoom);
			//_sprite.setPosition(x,y);
		}
	}
}