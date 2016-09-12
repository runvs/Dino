package;

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
		
		
		level = new TiledLevel(levelName);
		add(level.bg);
		//add(level.foregroundTiles);
		//add(level.collisionMap);
		
		d = new Dino();
		d.setPosition(100, -20);
		add(d);
	
		FlxG.camera.follow(d);
		bottom = new FlxSprite();
		bottom.makeGraphic(FlxG.width, 10, FlxColor.WHITE);
		bottom.setPosition(0, FlxG.height - bottom.height- 10);
		bottom.immovable = true;
		//add(bottom);
		
	}

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
