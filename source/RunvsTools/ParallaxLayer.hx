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
	
		if (parallaxName == "mountain")
		{
			var s : FlxSprite = new FlxSprite(0, 0);
			s.loadGraphic(AssetPaths.bg__png, false, 325, 150);
			s.origin.set();
			s.scale.set(GP.CameraMain.zoom, GP.CameraMain.zoom);
			add(s);
			
			this.scrollFactor.set(0.15, 0);
			return;
		}
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