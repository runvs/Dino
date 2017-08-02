package;
import flixel.FlxG;
import flixel.math.FlxPoint;
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
	private var _originalPosition : FlxPoint;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		this.makeGraphic(GP.WorldTileSizeInPixel, Std.int(GP.WorldTileSizeInPixel/2), FlxColor.fromRGB(255, 0, 0, 100));
		_sprite.makeGraphic(Std.int(GP.WorldTileSizeInPixel * GP.CameraMain.zoom), Std.int(GP.WorldTileSizeInPixel / 2 * GP.CameraMain.zoom), FlxColor.fromRGB(255, 255, 255, 255));
		_originalPosition = new FlxPoint(X, Y);
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		_sprite.update(elapsed);

		//trace("w: "  + _wiggleTimer + "b: " + breakTimer);
		
		if (_wiggle)
		{
			_wiggleTimer -= elapsed;
			if (_wiggleTimer <= 0)
			{
				_wiggleTimer = 0.1;
				_sprite.offset.set(FlxG.random.floatNormal(0, 4), FlxG.random.floatNormal(0, 4));
			}
		}
		
		if (!breaking)
		{
			if (_dino != null)
			{
				if (_touched)
				{
					//trace("touched");
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
				_sprite.acceleration.set(0, 1.2*GP.WorldGravity);
				_sprite.velocity.set(0, 300);
				this.setPosition( -5000000, -5000000);
				this.alive = false;
			}
			if (breakTimer <= GP.WorldBreakableRespawnTime)
			{
				resetMe();
			}
		}
	}
	
	override public function resetMe() 
	{
		//trace("reset");
		super.resetMe();
		_following = true;
		breakTimer = 0.5;
		breaking = false;
		_touched = false;
		_sprite.velocity.set(0, 0);
		_sprite.acceleration.set(0, 0);
		_wiggle = false;
		_sprite.offset.set();
		_sprite.color = FlxColor.WHITE;
		setPosition(_originalPosition.x, _originalPosition.y);
	}
	
	override public function resetCamera() 
	{
		//super.resetCamera();
		_sprite.cameras = [GP.CameraOverlay];
	}
	
	override function SpriteFollows():Void 
	{
		_sprite.setPosition((x + GP.WorldTileSizeInPixel/2) * GP.CameraMain.zoom + 8  , (y+ GP.WorldTileSizeInPixel/2) * GP.CameraMain.zoom - 4);
	}
}