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
		//level.bg.y = (FlxG.height/5) - level.bg.height;
		add(level.bg);
		
		var s2 : FlxSprite = new FlxSprite( 100, 100);
		s2.makeGraphic(400, 1, FlxColor.ORANGE);
		s2.cameras = [GP.CameraOverlay];
		add(s2);
		
		d = new Dino();
		d.setPosition(0,0);
		add(d);
		//GP.CameraMain.follow(d);
		
		//var st: FlxSprite = new FlxSprite(0,0);
		//st.makeGraphic(1, 1, FlxColor.WHITE);
		//st.cameras = [GP.CameraMain];
		//add(st);
		GP.CameraMain.follow(d, FlxCameraFollowStyle.TOPDOWN, 0.15);
		
		GP.CameraMain.targetOffset.set(FlxG.width/GP.CameraMain.zoom/10, FlxG.height/GP.CameraMain.zoom/10);
		
		_flocks = new Flocks(function(s) { s.makeGraphic(1, 1, FlxColor.fromRGB(175,175,175, 150)); }, 20, GP.CameraMain );
		add(_flocks);
		
	}
	
	
	
		//FlxG.camera.follow(d);
		//bottom = new FlxSprite();
		//bottom.makeGraphic(FlxG.width, 10, FlxColor.WHITE);
		//bottom.setPosition(0, FlxG.height - bottom.height- 10);
		//bottom.immovable = true;
		////add(bottom);
		//
		
	//}
//
	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		//trace(GP.CameraMain.target.x);
		super.update(elapsed);
		level.foregroundTiles.update(elapsed);
		level.collisionMap.update(elapsed);
		FlxG.collide(d, level.collisionMap);
	}
}
