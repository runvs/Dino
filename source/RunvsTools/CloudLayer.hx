package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.display.BlendMode;

/**
 * ...
 * @author 
 */
class CloudLayer extends ScreenWrappingSpriteGroup
{
	
	public var cloudName : String = "none";

	public function new(n : String) 
	{
		super(GP.CameraUnderlay, 32 * GP.CameraMain.zoom);
		cloudName = n;
		if (cloudName == "none") return;
		trace("loading clouds: " + cloudName); 
		
		for (i in 0 ... 8)
		{
			var x : Int = FlxG.random.int(-32, FlxG.width + 32);
			var y : Int = FlxG.random.int(0, FlxG.height );
		
			var f : Float = FlxG.random.float (0.8, 1.25);
			
			var name : String  = "assets/images/cloud_" + cloudName + ".png";
			var s : FlxSprite = new FlxSprite(x, y);
			var v : Int = FlxG.random.int(0,4);
			s.loadGraphic(name, true, 32, 16);
			s.animation.add("idle", [v], 1, true);
			
			s.velocity.x = FlxG.random.floatNormal(4, 0.25) * f; 
			if (s.velocity.x < 1) s.velocity.x = 1;
			s.velocity.y = 0;
			s.alpha = FlxG.random.float(0.5, 0.8) / f;
			s.scale.set(GP.CameraMain.zoom+1, GP.CameraMain.zoom+1);
			//s.scrollFactor.set(0.15/f, 0.05/f);
			s.blend = BlendMode.LIGHTEN;
			add(s);
		}
		this.scrollFactor.set(0.25, 0.05);
		
	}
	
	public function resetCamera()
	{
		this.cameras = [GP.CameraUnderlay];
		_cam = GP.CameraUnderlay;
		for (i in 0...this.length)
		{
			this.members[i].cameras = [GP.CameraUnderlay];
		}
	}
}