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

	public function new(n : String, count : Float = 2) 
	{
		super(GP.CameraUnderlay, 64 * GP.CameraMain.zoom);
		parallaxName = n;
		if (parallaxName == "none") return;
		trace("loading parallax: " + parallaxName); 
		
		
		//var N :Int = count;
		var dx : Float = 256 * GP.CameraMain.zoom;
		var N : Int = 4;
		for (i in 0 ... N)
		{
			var v : Int = FlxG.random.int(1, 1);
			var name : String  = "assets/images/parallax_" + parallaxName + Std.string(v) + ".png";
			
			var s : FlxSprite = new FlxSprite(0,0);
			s.loadGraphic(name, false, 256, 128);
			var x : Float = i * dx/count ;// + FlxG.random.float(0, dx / 2 );
			var y : Float = FlxG.height - s.height;
			s.setPosition(x, y);
			
			s.scale.set(GP.CameraMain.zoom, GP.CameraMain.zoom);
			add(s);
		}
		this.scrollFactor.set(0.15, 0);
		
		
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