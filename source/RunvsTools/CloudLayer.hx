package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class CloudLayer extends ScreenWrappingSpriteGroup
{
	
	public var cloudName : String = "none";

	public function new(n : String) 
	{
		super(GP.CameraUnderlay, 64 * GP.CameraMain.zoom);
		cloudName = n;
		if (cloudName == "none") return;
		trace("loading clouds: " + cloudName); 
		
		for (i in 0 ... 5)
		{
			var x : Int = FlxG.random.int(-64, FlxG.width + 64 );
			var y : Int = FlxG.random.int(0, FlxG.height );
		
			var f : Float = FlxG.random.float (0.8, 1.25);
			
			var v : Int = FlxG.random.int(1, 3);
			var name : String  = "assets/images/cloud_" + cloudName + Std.string(v) + ".png";
			var s : FlxSprite = new FlxSprite(x,y);
			s.loadGraphic(name, false, 64, 32);
			s.velocity.x = FlxG.random.floatNormal(4, 0.25) * f; 
			if (s.velocity.x < 1) s.velocity.x = 1;
			s.velocity.y = 0;
			s.alpha = FlxG.random.float(0.45, 0.95) / f;
			s.scale.set(GP.CameraMain.zoom*f, GP.CameraMain.zoom*f);
			//s.scrollFactor.set(0.15/f, 0.05/f);
			add(s);
		}
		this.scrollFactor.set(0.15, 0.05);
		
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