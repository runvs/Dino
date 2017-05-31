package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author 
 */
class GrassArea extends FlxTypedGroup<Grass>
{	
	public function new(X:Float, Y:Float, W:Float) 
	{
		super();
		var inverseDensity : Int = 6;
		var N : Int = Std.int(W / inverseDensity);
		for (i in 0...N)
		{
			var x : Float = X + i * inverseDensity + FlxG.random.int(-2, 2);
			var s : Grass = new Grass(Std.int(x), Y - 8);
			add(s);
		}
		this.cameras = [GP.CameraMain];
	}
	
	public function resetCamera()
	{
		this.cameras = [GP.CameraMain];
		for (s in this)
		{
			s.resetCamera();
		}
	}
	
}