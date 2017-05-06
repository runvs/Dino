package;
import flixel.FlxObject;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class EnemyWalkLR extends BasicEnemy
{
	
	public var distance : Float = 0;
	private var _startingPos : Float = 0;
	private var _walkingRight : Bool = true;
	
	public function new(X: Float, Y: Float) 
	{
		super(X, Y);
		//this.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		//_sprite.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		
		this.makeGraphic(20, 10, FlxColor.RED);
		_sprite.loadGraphic(AssetPaths.Enemy_FOX__png, true, 20, 16);
		_sprite.animation.add("walk", [0, 1, 2, 3], 7);
		_sprite.animation.play("walk");
		//_sprite.offset.set(0, -6);
		_sprite.setFacingFlip(FlxObject.LEFT, true, false);
		_sprite.setFacingFlip(FlxObject.RIGHT, false, false);
		_startingPos = X;
	}
	
	public override function update(elapsed:Float)
	{
		//trace(this.x);
		super.update(elapsed);
		//_sprite.setPosition(x, 
		if (_walkingRight)
		{
			_sprite.facing = FlxObject.LEFT;
			this.velocity.x = GP.EnemyWalkLRSpeed;
			if (this.x - _startingPos > distance)
			{
				_walkingRight = false;
				this.x = _startingPos + distance;
			}
		}
		else
		{
			_sprite.facing = FlxObject.RIGHT;
			this.velocity.x = -GP.EnemyWalkLRSpeed;
			if (this.x - _startingPos < 0)
			{
				_walkingRight = true;
				this.x = _startingPos;
			}
		}
		
	}
	
}