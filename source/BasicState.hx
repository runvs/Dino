package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
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
	var _droplets : Droplets;
	
	var _fade2BlackTween : FlxTween = null;
	
	var _speechbubbles : SpeechBubbleManager;
	
	
	public var _moonSprite : FlxSprite;
	
	var inTransition : Bool = false;
	private var _overlay :FlxSprite;
	
	var _infostring : FlxText;
	
	
	public function new() 
	{
		super();
	}
	
	public override function create()  
	{
		trace("BasicState Create");
		trace("BasicState pre super.create(), number of cameras: " + FlxG.cameras .list.length);
		super.create();
		GP.CamerasCreate();
				
		trace("BasicState, number of cameras: " + FlxG.cameras .list.length);
		trace ("Basicstate create moon");
		_moonSprite = new FlxSprite(400, -100);
		_moonSprite.loadGraphic(AssetPaths.moon__png, false, 450, 450);
		_moonSprite.cameras = [GP.CameraUnderlay];
		_moonSprite.scrollFactor.set(0.1, 0);
		_moonSprite.color = FlxColor.fromRGB(200,200,200);
		_moonSprite.alpha = 1.0;
		_moonSprite.scale.set(0.5, 0.5);
		
		trace ("Basicstate create flakes n stars");
		_flakes = new Flakes(GP.CameraOverlay, 10, 70);
		
		_stars = new StarField(GP.CameraUnderlay, 10);
		_stars.scrollFactor.set(0.1, 0);
		
		_droplets = new Droplets();
		
		
		trace ("Basicstate create vignette");
		_vignette = new Vignette(GP.CameraOverlay);
		
		_overlay = new FlxSprite(0, 0);
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);
		
		_overlay.scrollFactor.set();
		_overlay.alpha = 1.0;
		_overlay.cameras = [GP.CameraOverlay ];
		_fade2BlackTween = FlxTween.tween(_overlay, { alpha:0.0 }, 0.5);
		
		_overlay.alpha = 0;
		
		_speechbubbles = new SpeechBubbleManager();
	
		
		_infostring = new FlxText(10, 10, 0, "");
		_infostring.scrollFactor.set();
		_infostring.cameras = [GP.CameraOverlay];
		
		
		trace("Basicstate create end");
	}
	
	public function LoadLevel(l : String)
	{
		_levelName = l;
		//trace("BasicState LoadLevel");
		//_level = new TiledLevel(_levelName);
		
		_speechbubbles.clear();
		
		_level = GP.WorldMapPool.getLevel(_levelName);
		_level.resetCameras();
		
		
		
		FlxG.worldBounds.set(0, 0, _level.width * GP.WorldTileSizeInPixel, _level.height * GP.WorldTileSizeInPixel);
		
		GP.CameraUnderlay.setScrollBounds(
		1.85* GP.WorldTileSizeInPixel * GP.CameraMain.zoom, (_level.width-0.45) * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, 
		1 * GP.WorldTileSizeInPixel * GP.CameraMain.zoom, (_level.height)  * GP.WorldTileSizeInPixel * GP.CameraMain.zoom);
		
		GP.CameraMain.setScrollBounds(
		6 * GP.WorldTileSizeInPixel, (_level.width - 5.7) * GP.WorldTileSizeInPixel, 
		4 * GP.WorldTileSizeInPixel, (_level.height- 4) * GP.WorldTileSizeInPixel);
		
		GP.CameraOverlay.setScrollBounds(
		1.95* GP.WorldTileSizeInPixel * GP.CameraMain.zoom, (_level.width-0.45) * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, 
		1 * GP.WorldTileSizeInPixel * GP.CameraMain.zoom, (_level.height)  * GP.WorldTileSizeInPixel * GP.CameraMain.zoom);
				
		//trace(GP.CameraUnderlay.minScrollX + " " + GP.CameraUnderlay.maxScrollX + " " + GP.CameraUnderlay.minScrollY + " " + GP.CameraUnderlay.maxScrollY);
		//trace(GP.CameraMain.minScrollX + " " + GP.CameraMain.maxScrollX + " " + GP.CameraMain.minScrollY + " " + GP.CameraMain.maxScrollY);
		//trace(GP.CameraOverlay.minScrollX + " " + GP.CameraOverlay.maxScrollX + " " + GP.CameraOverlay.minScrollY + " " + GP.CameraOverlay.maxScrollY);
		
		ResetFade2Black();
	}
	
	// should be overwritten by child classes
	public function internalUpdate(elapsed: Float) 
	{
	//trace("BasicState internalUpdate");	
		
	}
	
	public override function update(elapsed: Float) : Void 
	{
		
		//trace("basicstate update");
		super.update(elapsed);
		_infostring.text = "";
		_infostring.text += "FPS: " + 1.0 / elapsed + "\n";
		_infostring.text += "\nLevel: " + _levelName + "\n";
		_infostring.text += "CollisionBoxes: " + _level.collisionMap.length + "\n";
		
		_flakes.update(elapsed);
		_stars.update(elapsed);
		_level.collisionMap.update(elapsed);
		_level.bg.update(elapsed);
		_level.clouds.update(elapsed);
		_level.parallax.update(elapsed);
		_level.foregroundTiles.update(elapsed);
		_level.foregroundTiles2.update(elapsed);
		_level.topTiles.update(elapsed);
		_level.wind.update(elapsed);
	
		//trace(_overlay.alpha);
		
		for (t in _level.trees)
		{
			t.update(elapsed);
		}
		for (t in _level.treesTop)
		{
			t.update(elapsed);
		}
		
		if (_level.drawDroplets)
		{
			_droplets.update(elapsed);
		}
		
		for (d in _level.doors)
		{
			d.update(elapsed);
		}
		
		for (g in _level.grass)
		{
			g.update(elapsed);
		}
		
		for (h in _level.hurtingTiles)
		{
			h.update(elapsed);
		}
		for (s in _level.movingTiles)
		{
			s.update(elapsed);
		}
		
		if (!inTransition)
		{
			//trace("BasicState update");
			MyInput.update();
			_speechbubbles.update(elapsed);
			internalUpdate(elapsed);
		}
		//trace("basicstate update end");
		
		
	}
	
	// should be overwritten by child classes
	public function internalDraw() : Void 
	{
		//trace("BasicState internal draw");
	}
	
	// should be overwritten by child classes
	public function internalDrawTop() : Void
	{
		
	}
	
	public override function draw() : Void 
	{
		//trace("BasicState draw");
		_level.bg.draw();

		if (_level.drawStars)
		{
			_stars.draw();
		}
		
		if (_level.drawMoon)
		{
			_moonSprite.draw();
		}
		
		if (_level.parallaxName != "none")
		{
			_level.parallax.draw();
		}
		
		if (_level.cloudName != "none")
		{
			_level.clouds.draw();
		}
		
		
		
		if (_level.drawFlocks)
		{
			_flakes.draw();
		}
		
		if (_level.drawDroplets)
		{
			_droplets.draw();
		}
		_level.foregroundTiles.draw();
		for (s in _level.movingTiles)
		{
			s.draw();
		}
		_level.foregroundTiles2.draw();
		for (t in _level.trees)
		{
			t.draw();
		}
		
		for (h in _level.hurtingTiles)
		{
			h.draw();
		}
		
		super.draw();
		for (g in _level.grass)
		{
			g.draw();
		}
		
		
		for (d in _level.doors)
		{
			d.draw();
		}
		_speechbubbles.draw();
		internalDraw();
		
		_level.topTiles.draw();
		for (t in _level.treesTop)
		{
			t.draw();
		}
		
		//_level.collisionMap.draw();
		
		_vignette.draw();
		
		internalDrawTop();
		
		_overlay.draw();
		
		_infostring.draw();
	}
	
	public function Fade2Black()
	{
		if (_fade2BlackTween != null)
		{
			_fade2BlackTween.cancel();
		}
		
		//_overlay.alpha = 1;
		_fade2BlackTween = FlxTween.tween(_overlay,{ alpha : 1 }, 0.25);
	}
	public function ResetFade2Black()
	{
		if (_fade2BlackTween != null)
		{
			_fade2BlackTween.cancel();
		}
		_overlay.alpha = 1;
		_fade2BlackTween = FlxTween.tween(_overlay, { alpha : 0 }, 0.25, {startDelay:0.1});
		//_overlay.alpha = 0;
	}
	
	public function jumpToEntryPoint(id : Int)
	{
		ResetFade2Black();
	}
	
	public function addSpeechBubble (s : SpeechBubble)
	{
		_speechbubbles.addSpeechBubble(s);
	}
	
}