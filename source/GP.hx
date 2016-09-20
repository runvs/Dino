package;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
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
	
	
	public static var WorldGravity (default, null) : Float = 175;
	public static var WorldTileSizeInPixel (default, null) : Int = 16;
	
	public static var MenuItemsOffsetX (default, null) : Float = 16;
	public static var MenuItemsOffsetY (default, null) : Float = 16;
	public static var MenuItemsPadding (default, null) : Float = 2;
	public static var MenuItemsSize (default, null) : Float = 24;
	
	public static var CameraZoom (default, null) : Float = 5;
	public static var CameraUnderlay (default, default) : FlxCamera;
	public static var CameraMain (default, default) : FlxCamera;// = ;
	public static var CameraOverlay (default, default) : FlxCamera;// = new FlxCamera(0, 0, 800, 600, 1);
	
	public static function CamerasCreate()
	{
		trace("setting cameras");
		CameraUnderlay = new FlxCamera(0, 0, 800, 600, 1);
		
		
		CameraMain = new FlxCamera(0, 0, Std.int(FlxG.width / CameraZoom), Std.int(FlxG.height / CameraZoom), CameraZoom);
		CameraMain.pixelPerfectRender = true;
		CameraMain.bgColor = FlxColor.TRANSPARENT;
		
		CameraOverlay = new FlxCamera(0, 0, 800, 600, 1);
		CameraOverlay.bgColor = FlxColor.TRANSPARENT;
		//trace(CameraMain.pixelPerfectRender);
		
		
		
		// check if camera List has to be cleared
		FlxG.cameras.reset(GP.CameraUnderlay);
		FlxG.cameras.add(GP.CameraMain);
		FlxG.cameras.add(GP.CameraOverlay);
		
	}
	
	public static function CamerasFollow(tracerMain : FlxObject, tracer : FlxObject)
	{
		GP.CameraUnderlay.focusOn(new FlxPoint(tracer.x, tracer.y));
		GP.CameraUnderlay.follow(tracer, FlxCameraFollowStyle.LOCKON , 0.20);
		
		GP.CameraMain.focusOn(new FlxPoint(tracerMain.x, tracerMain.y));
		GP.CameraMain.follow(tracerMain, FlxCameraFollowStyle.LOCKON, 0.20);
		
		GP.CameraOverlay.focusOn(new FlxPoint(tracer.x, tracer.y));
		GP.CameraOverlay.follow(tracer, FlxCameraFollowStyle.LOCKON , 0.20);
	}
}