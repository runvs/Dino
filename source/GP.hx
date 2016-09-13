package;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class GP
{
	
	public static var DinoMovementDragX (default, null) : Float = 1000;
	public static var DinoMovementDragY (default, null) : Float = 100;
	
	public static var DinoMovementMaxVelocityX (default, null) : Float = 40;
	public static var DinoMovementMaxVelocityY (default, null) : Float = 80;
	
	public static var DinoMovementAccelerationFactor (default, null) : Float = 300;
	
	public static var DinoMovementJumpStrength (default, null) : Float = -100;
	
	
	public static var WorldGravity (default, null) : Float = 150;
	public static var WorldTileSizeInPixel (default, null) : Int = 16;
	
	public static var CameraMain (default, default) : FlxCamera;// = ;
	public static var CameraOverlay (default, default) : FlxCamera;// = new FlxCamera(0, 0, 800, 600, 1);
	
	public static function CamerasCreate()
	{
		trace("setting cameras");
		CameraMain = new FlxCamera(0, 0, 800, 600, 5);
		CameraOverlay = new FlxCamera(0, 0, 800, 600, 1);
		CameraOverlay.bgColor = FlxColor.TRANSPARENT;
		trace(CameraMain.pixelPerfectRender);
		CameraMain.pixelPerfectRender = true;
		
		// check if camera List has to be cleared
		FlxG.cameras.reset(GP.CameraMain);
		FlxG.cameras.add(GP.CameraOverlay);
		
		
	}
	
}