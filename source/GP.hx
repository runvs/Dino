package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class GP
{
	public static var DinoMovementDragX (default, null) : Float = 250;
	public static var DinoMovementDragY (default, null) : Float = 80;
	
	public static var DinoMovementMaxVelocityX (default, null) : Float = 55;
	public static var DinoMovementMaxVelocityY (default, null) : Float = 120;
	
	public static var DinoMovementAccelerationFactor (default, null) : Float = 250;
	
	public static var DinoMovementJumpStrength (default, null) : Float = -230;
	
	public static var LevelHurtingFallingXMarginFactor (default, null) : Float = 1.5;
	public static var LevelHurtingFallingVelocity (default, null) : Float = 80;
	public static var LevelHurtingFallingDelay  (default, null) : Float = 0.5;
	public static var LevelHurtingFallingWiggleDeadTime (default, null) : Float = 1.25;
	
	public static var WorldGravity (default, null) : Float = 175;
	public static var WorldTileSizeInPixel (default, null) : Int = 16;
	
	public static var WorldWindUpdateTime (default, null) : Float = 0.125;
	public static var WorldWindSpeedInPixelsPerSecond (default, null) : Float = 60;
	
	public static var WorldFlakesVisibleTime (default, null) : Float = 6;
	public static var WorldFlakesInvisibleTime (default, null) : Float = 4;
	
	public static var MenuItemsOffsetX (default, null) : Float = 16;
	public static var MenuItemsOffsetY (default, null) : Float = 16;
	public static var MenuItemsPadding (default, null) : Float = 2;
	public static var MenuItemsSize (default, null) : Float = 24;
	
	public static var CameraZoom (default, null) : Float = 4;
	public static var CameraUnderlay (default, default) : FlxCamera;
	public static var CameraMain (default, default) : FlxCamera;// = ;
	public static var CameraOverlay (default, default) : FlxCamera;// = new FlxCamera(0, 0, 800, 600, 1);
	
	public static var EnemyWalkLRSpeed (default, null) : Float = 15;
	
	public static var WorldMapPool (default, null) : MapPool;
	public static var EnemyBoarRange (default, null) : Float = 80;
	public static var EnemyBoarChargeCoolDown (default, null) : Float = 5;
	public static var EnemyBoarChargeAcceleration (default, null) : Float = 20;
	
	public static var FishingTimerMax (default, null) : Float = 3.0;
	static public var DinoMoveMentJumpLeftGroundTolerance (default, null) : Float = 0.22;
	static public var DinoMovementJumpPreHoldTimer (default, null) : Float = 0.1;
	
	public static function WorldLoadMaps() : Void 
	{
		WorldMapPool = new MapPool();
	}
	
	
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
		trace("GP.CreateCameras, number of cameras: " + FlxG.cameras.list.length);
	}
	
	public static function CamerasFollow(tracerMain : FlxObject, tracer : FlxObject)
	{
		GP.CameraUnderlay.focusOn(new FlxPoint(tracer.x, tracer.y));
		GP.CameraUnderlay.follow(tracer, FlxCameraFollowStyle.LOCKON , 0.20);
		//trace("underlay: " + GP.CameraUnderlay.deadzone);
		
		GP.CameraMain.focusOn(new FlxPoint(tracerMain.x, tracerMain.y));
		GP.CameraMain.follow(tracerMain, FlxCameraFollowStyle.LOCKON, 0.20);
		//trace("main: " + GP.CameraMain.deadzone);
		
		GP.CameraOverlay.focusOn(new FlxPoint(tracer.x, tracer.y));
		GP.CameraOverlay.follow(tracer, FlxCameraFollowStyle.LOCKON , 0.20);
		//GP.CameraOverlay.deadzone = new FlxRect(GP.CameraOverlay.deadzone.x, GP.CameraOverlay.deadzone.y, GP.CameraOverlay.deadzone.width, GP.CameraOverlay.deadzone.height);
		//trace("overlay: " + GP.CameraOverlay.deadzone);
	}
}