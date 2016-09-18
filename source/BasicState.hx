package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class BasicState extends FlxState
{
	var _level : TiledLevel;
	var _levelName : String;
	
	var _vignette : Vignette;
	var _flakes : Flakes;
	var _stars : StarField;
	
	public var _moonSprite : FlxSprite;
	
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
				
		_moonSprite = new FlxSprite(100, -100);
		_moonSprite.loadGraphic(AssetPaths.moon__png, false, 450, 450);
		_moonSprite.cameras = [GP.CameraUnderlay];
		_moonSprite.scrollFactor.set(0.1, 0);
		_moonSprite.color = FlxColor.fromRGB(200,200,200);
		_moonSprite.alpha = 1.0;
		_moonSprite.scale.set(0.5, 0.5);
		
		_flakes = new Flakes(GP.CameraMain, 10);
		
		_stars = new StarField(GP.CameraUnderlay, 10);
		_stars.scrollFactor.set(0.1, 0);
		
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
	
		GP.CameraUnderlay.setScrollBounds( 
		-1 * GP.WorldTileSizeInPixel * GP.CameraMain.zoom, (_level.width - 1) * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, 
		-10 * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, (_level.height)  * GP.WorldTileSizeInPixel* GP.CameraMain.zoom);
	
		
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
		_flakes.update(elapsed);
		_stars.update(elapsed);
		_level.collisionMap.update(elapsed);
		_level.bg.update(elapsed);
		_level.foregroundTiles.update(elapsed);
		_level.foregroundTiles2.update(elapsed);
		
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
		
		
		_stars.draw();
		_moonSprite.draw();
		
		//_flakes.draw();
		
		_level.foregroundTiles.draw();
		_level.foregroundTiles2.draw();
		
		super.draw();
		internalDraw();
		
		_vignette.draw();
		_overlay.draw();
	}
	
}