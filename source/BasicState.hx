package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
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
	
	var inTransition : Bool = false;
	var _overlay :FlxSprite;
	public function new() 
	{
		super();
	}
	
	public override function create()  
	{
		//trace("BasicState Create");
		super.create();
		GP.CamerasCreate();
		
		_flocks = new Flocks(function(s) { s.makeGraphic(1, 1, FlxColor.fromRGB(175, 175, 175, 175)); }, 25, GP.CameraMain );
		_vignette = new Vignette(GP.CameraOverlay);
		_overlay = new FlxSprite(0, 0);
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_overlay.scrollFactor.set();
		_overlay.alpha = 1.0;
		FlxTween.tween(_overlay, { alpha:0.0 }, 0.5);
		
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
		super.update(elapsed);
		_flocks.update(elapsed);
		_level.collisionMap.update(elapsed);
		if (!inTransition)
		{
			//trace("BasicState update");
			MyInput.update();
			
			internalUpdate(elapsed);
		}
		
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
		_level.foregroundTiles.draw();
		_level.foregroundTiles2.draw();
		
		
		super.draw();
		internalDraw();
		
		_vignette.draw();
		_overlay.draw();
	}
	
}