package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class ParallaxLayer extends ScreenWrappingSpriteGroup
{
	
	public var parallaxName : String = "none";

	public function new(n : String) 
	{
		super(GP.CameraUnderlay, 64 * GP.CameraMain.zoom);
		parallaxName = n;
		if (parallaxName == "none") return;
		trace("loading parallax: " + parallaxName); 
		
		
		for (i in 0 ... 2)
		{
			var x : Int = FlxG.random.int(-64, FlxG.width + 64 );
			var y : Int = FlxG.random.int(0, FlxG.height );
		
			var v : Int = FlxG.random.int(1, 1);
			var name : String  = "assets/images/parallax_" + parallaxName + Std.string(v) + ".png";
			
			var s : FlxSprite = new FlxSprite(x,y);
			s.loadGraphic(name, false, 128,64);
			s.scale.set(GP.CameraMain.zoom, GP.CameraMain.zoom);
			add(s);
		}
		this.scrollFactor.set(0.1, 0);
		
		
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