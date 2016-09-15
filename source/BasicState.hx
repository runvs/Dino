package;

import flixel.FlxState;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class BasicState extends FlxState
{

	var _flocks : Flocks;
	
	var _level : TiledLevel;
	var _levelName : String;
	
	var _vignette : Vignette;
	
	public function new() 
	{
		super();
	}
	
	public override function create()  
	{
		//trace("BasicState Create");
		super.create();
		GP.CamerasCreate();
		
		_flocks = new Flocks(function(s) { s.makeGraphic(1, 1, FlxColor.fromRGB(175, 175, 175, 175)); }, 20, GP.CameraMain );
		_vignette = new Vignette(GP.CameraOverlay);
	}
	
	public function LoadLevel()
	{
		//trace("BasicState LoadLevel");
		_level = new TiledLevel(_levelName);
		
		GP.CameraMain.setScrollBounds( 
		1 * GP.WorldTileSizeInPixel, (_level.width - 1) * GP.WorldTileSizeInPixel, 
		-10 * GP.WorldTileSizeInPixel, (_level.height) * GP.WorldTileSizeInPixel);
		
		GP.CameraOverlay.setScrollBounds( 
		-1 * GP.WorldTileSizeInPixel * GP.CameraMain.zoom, (_level.width - 1) * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, 
		-10 * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, (_level.height)  * GP.WorldTileSizeInPixel* GP.CameraMain.zoom);
		
	}
	
	// should be overwritten by child classes
	public function internalUpdate(elapsed: Float) 
	{
	//trace("BasicState internalUpdate");	
		
	}
	
	public override function update(elapsed: Float) : Void 
	{
		//trace("BasicState update");
		MyInput.update();
		super.update(elapsed);
		_flocks.update(elapsed);
		_level.collisionMap.update(elapsed);
		internalUpdate(elapsed);
		
	}
	
	// should be overwritten by child classes
	public function internalDraw() : Void 
	{
		//trace("BasicState internal draw");
	}
	
	public override function draw() : Void 
	{
		//trace("BasicState draw");
		_level.bg.draw();
		_flocks.draw();
		
		super.draw();
		internalDraw();
		
		_vignette.draw();
	}
	
}