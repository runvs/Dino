package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
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
	
	public function new ( n : String )
	{
		super();
		levelName = n;
	}
	
	override public function create():Void
	{
		super.create();
		//GP.CameraMain = new FlxCamera(0, 0, 100, 75, 8);
		//GP.CameraOverlay = new FlxCamera(0, 0, 800, 600, 1);
		//GP.CameraOverlay.bgColor = FlxColor.TRANSPARENT;
		//FlxG.cameras.add(GP.CameraMain);
		//FlxG.cameras.add(GP.CameraOverlay);
		GP.CamerasCreate();
		
		//var s1 : FlxSprite = new FlxSprite( 20, 20);
		//s1.makeGraphic(2, 2, FlxColor.RED);
		//s1.velocity.x = 10;
		//s1.cameras = [GP.CameraMain];
		//add(s1);
	
		level = new TiledLevel(levelName);
		add(level.bg);
		//add(level.foregroundTiles);
		//add(level.collisionMap);
	
				var s2 : FlxSprite = new FlxSprite( 100, 100);
		s2.makeGraphic(400, 1, FlxColor.ORANGE);
		s2.cameras = [GP.CameraOverlay];
		add(s2);
		
		d = new Dino();
		d.setPosition(20, 20);
		add(d);
		

	}
	
	
	
		//FlxG.camera.follow(d);
		//bottom = new FlxSprite();
		//bottom.makeGraphic(FlxG.width, 10, FlxColor.WHITE);
		//bottom.setPosition(0, FlxG.height - bottom.height- 10);
		//bottom.immovable = true;
		////add(bottom);
		//
		//var s1 : FlxSprite = new FlxSprite( 2, 2);
		//s1.makeGraphic(2, 2, FlxColor.RED);
		//s1.cameras = [GP.CameraMain];
		//add(s1);
	//}
//
	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		
		//FlxG.collide(d, bottom);
		level.foregroundTiles.update(elapsed);
		level.collisionMap.update(elapsed);
		FlxG.collide(d, level.collisionMap);
	}
}
