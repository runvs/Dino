package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;


/**
 * ...
 * @author 
 */
class Droplets extends ScreenWrappingSpriteGroup
{
	private static var fallingVelocityStart : Float = 50;
	
	public function new(N : Int = 3) 
	{
		super(GP.CameraMain, 3);
		for (i in 0 ... N)
		{
			var s : FlxSprite = new FlxSprite( FlxG.random.float(-_padding, _cam.width + _padding), FlxG.random.float(-_padding, _cam.height + _padding));
			s.cameras = [GP.CameraMain];
			s.makeGraphic(1, 1, FlxColor.fromRGB(47,55,64));
			s.acceleration.set(0, 30);
			s.velocity.set(0, fallingVelocityStart);
			add(s);
		}	
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		for (s in this)
		{
			var v : Float = s.scale.y + 0.5 * elapsed;
			
			s.scale.set(1/Math.sqrt(v) , v);
		}
	}
	
	override public function wrapAndDo(s:FlxSprite, horizontal:Bool = false) 
	{
		super.wrapAndDo(s, horizontal);
		if (!horizontal)
		{
			s.velocity.set(0, fallingVelocityStart);
			s.scale.set(1, 1);
			s.x += FlxG.random.float(0, _cam.width);
		}
	}
}