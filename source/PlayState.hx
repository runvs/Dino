package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var d : Dino;
	var doverlay : FlxSprite;
	
	var bottom : FlxSprite;
	
	var _level : TiledLevel;
	
	var levelName : String;
	
	var _flocks : Flocks;
	
	public function new ( n : String )
	{
		super();
		levelName = n;
	}
	
	override public function create():Void
	{
		super.create();
		GP.CamerasCreate();
		
		//var s1 : FlxSprite = new FlxSprite( 2, 2);
		//s1.makeGraphic(2, 2, FlxColor.RED);
		//s1.velocity.x = 10;
		//s1.cameras = [GP.CameraMain];
		//add(s1);
		
		_level = new TiledLevel(levelName);
		
				
		add(_level.bg);
		
		_flocks = new Flocks(function(s) { s.makeGraphic(1, 1, FlxColor.fromRGB(175,175,175, 175)); }, 20, GP.CameraMain );
		add(_flocks);
		
		add(_level.foregroundTiles);
		add(_level.foregroundTiles2);
		
		GP.CameraMain.setScrollBounds( 
		-2 * GP.WorldTileSizeInPixel, (_level.tileWidth + 6) * GP.WorldTileSizeInPixel, 
		-10 * GP.WorldTileSizeInPixel, (_level.tileHeight-4) * GP.WorldTileSizeInPixel);
		
		GP.CameraOverlay.setScrollBounds( 
		-2 * GP.WorldTileSizeInPixel * GP.CameraMain.zoom, (_level.tileWidth + 6) * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, 
		-10 * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, (_level.tileHeight - 4)  * GP.WorldTileSizeInPixel* GP.CameraMain.zoom);
		
		var s2 : FlxSprite = new FlxSprite( 100, 100);
		s2.makeGraphic(400, 1, FlxColor.ORANGE);
		s2.cameras = [GP.CameraOverlay];
		//add(s2);
		
		d = new Dino();
		add(d);
		d.setPosition(_level.getEntryPoint(1).x, _level.getEntryPoint(1).y);
		
		doverlay = new FlxSprite(d.x, d.y);
		//doverlay.makeGraphic(120, 90, FlxColor.TRANSPARENT);
		doverlay.makeGraphic(120, 90, FlxColor.RED);
		doverlay.alpha = 0.5;
		doverlay.cameras = [GP.CameraOverlay];
		add(doverlay);
		
		GP.CameraMain.follow(d, FlxCameraFollowStyle.LOCKON, 0.20);
		GP.CameraOverlay.follow(doverlay, FlxCameraFollowStyle.LOCKON , 0.20);
		
		var v : Vignette = new Vignette(GP.CameraOverlay);
		add(v);
		
	}
	
	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		doverlay.setPosition(d.x * GP.CameraMain.zoom, d.y * GP.CameraMain.zoom);
		super.update(elapsed);
		_level.foregroundTiles.update(elapsed);
		_level.collisionMap.update(elapsed);
		FlxG.collide(d, _level.collisionMap);
		d.touchedGround = d.isTouching(FlxObject.DOWN);
		CheckExits();
		for (e in _level.exits)
		{
			e.update(elapsed);
		}
		for (e in _level.entries)
		{
			e.update(elapsed);
		}
	}
	
	function CheckExits() 
	{
		d.isOnExit = false;
		for (e in _level.exits)
		{
			if (e.targetLevel == "") continue;
			if (FlxG.overlap(d, e))
			{
				
				trace("overlap");
				d.isOnExit = true;
				if (d.transport)
					SwitchLevel(e);
				break;
			}
		}
	}
	
	function SwitchLevel(e:Exit) 
	{
		_level = new TiledLevel("assets/data/" + e.targetLevel);
		var p : FlxPoint = _level.getEntryPoint(e.entryID);
		d.setPosition(p.x, p.y);
		d.teleport();
	}
	
	
	override public function draw ()
	{
		super.draw();
		
		for (e in _level.exits)
		{
			e.draw();
		}
		for (e in _level.entries)
		{
			e.draw();
		}
	}
}
