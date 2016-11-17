package;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class EnemyWalkLR extends BasicEnemy
{
	
	public var distance : Float = 0;
	private var startingPos : Float = 0;
	private var walkingRight : Bool = true;
	
	public function new(X: Float, Y: Float) 
	{
		super(X, Y);
		this.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		_sprite.makeGraphic(GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel, FlxColor.RED);
		
		startingPos = X;
	}
	
	public override function update(elapsed:Float)
	{
		//trace(this.x);
		super.update(elapsed);
		
		if (walkingRight)
		{
			this.velocity.x = GP.EnemyWalkLRSpeed;
			if (this.x - startingPos > distance)
			{
				walkingRight = false;
				this.x = startingPos + distance;
			}
		}
		else
		{
			this.velocity.x = -GP.EnemyWalkLRSpeed;
			if (this.x - startingPos < 0)
			{
				walkingRight = true;
				this.x = startingPos;
			}
		}
		
	}
	
}