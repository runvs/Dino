package;

import flixel.FlxCamera;
import flixel.FlxG;
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
	
	var level : TiledLevel;
	
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
		
		level = new TiledLevel(levelName);
		
		
		add(level.bg);
		add(level.foregroundTiles);
		
		GP.CameraMain.setScrollBounds( 
		-10 * GP.WorldTileSizeInPixel, 10 * GP.WorldTileSizeInPixel, 
		-10 * GP.WorldTileSizeInPixel, 4 * GP.WorldTileSizeInPixel);
		
		GP.CameraOverlay.setScrollBounds( 
		-10 * GP.WorldTileSizeInPixel * GP.CameraMain.zoom, 10 * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, 
		-10 * GP.WorldTileSizeInPixel* GP.CameraMain.zoom, 4 * GP.WorldTileSizeInPixel* GP.CameraMain.zoom);
		var s2 : FlxSprite = new FlxSprite( 100, 100);
		s2.makeGraphic(400, 1, FlxColor.ORANGE);
		s2.cameras = [GP.CameraOverlay];
		add(s2);
		
		d = new Dino();
		d.setPosition(0,0);
		add(d);
		
		doverlay = new FlxSprite(d.x, d.y);
		doverlay.makeGraphic(1, 1, FlxColor.TRANSPARENT);
		doverlay.cameras = [GP.CameraOverlay];
		add(doverlay);
		
		
		
		//var st: FlxSprite = new FlxSprite(0,0);
		//st.makeGraphic(1, 1, FlxColor.WHITE);
		//st.cameras = [GP.CameraMain];
		//add(st);
		GP.CameraMain.follow(d, FlxCameraFollowStyle.LOCKON, 0.20);
		GP.CameraMain.targetOffset.set(FlxG.width/GP.CameraMain.zoom/10, FlxG.height/GP.CameraMain.zoom/10);
		GP.CameraOverlay.follow(doverlay, FlxCameraFollowStyle.LOCKON , 0.20);
		
		_flocks = new Flocks(function(s) { s.makeGraphic(1, 1, FlxColor.fromRGB(175,175,175, 150)); }, 20, GP.CameraMain );
		add(_flocks);
		
	}
	
	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		doverlay.setPosition(d.x * GP.CameraMain.zoom, d.y * GP.CameraMain.zoom);
		super.update(elapsed);
		level.foregroundTiles.update(elapsed);
		level.collisionMap.update(elapsed);
		FlxG.collide(d, level.collisionMap);
	}
}
