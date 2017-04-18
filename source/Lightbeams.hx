package;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author 
 */
class Lightbeams extends ConditionalObject
{

	public function new(X:Float=0, Y:Float=0, exitRight:Bool=true) 
	{
		super();
		x = X;
		y = Y;
		this.loadGraphic(AssetPaths.lightbeams__png, true, 35, 18);
		this.cameras = [GP.CameraMain];
		this.alpha = 0.5;
		if (exitRight)
		{
			this.offset.set(35,18);	// center to bottom right corner
		}
		else
		{
			this.offset.set(0,18);	// center to bottom left corner
		}
		
		FlxTween.tween(this, { alpha:0.0 }, 5.5, { type:FlxTween.PINGPONG } );
		
	}
	
	public override function draw()
	{
		//trace("draw lightbeams");
		super.draw();
	}
	
}