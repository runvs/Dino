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
	
	
	
	override public function create():Void
	{
		super.create();
		d = new Dino();
		
		d.setPosition(100, 20);
		add(d);
		
		bottom = new FlxSprite();
		bottom.makeGraphic(FlxG.width, 10, FlxColor.WHITE);
		bottom.setPosition(0, FlxG.height - bottom.height- 10);
		bottom.immovable = true;
		add(bottom);
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		
		FlxG.collide(d, bottom);
	}
}
