package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class SpeechBubble extends FlxSprite
{
	
	private var _parent : FlxSprite;

	private var _timer : Float;
	
	private var _icon : FlxSprite;
	
	private var _age  : Float = 0;
	
	public function new(p: FlxSprite, i : String, d : Float) 
	{
		super();
		_parent = p;
		_timer = d;
		this.loadGraphic(AssetPaths.speechbubble__png, false, 16, 16);
		this.color = FlxColor.fromRGB(175, 175, 175, 175);
		this.cameras = [GP.CameraMain];
		
		
		LoadIcon(i);
		
	}
	
	public override function update (elapsed : Float) : Void 
	{
		super.update(elapsed);
		_age += elapsed;
		this.setPosition(_parent.x + _parent.width/2, _parent.y- this.height/3*2);
		_icon.update(elapsed);
		_icon.setPosition(x, y);
		_timer -= elapsed;
		if (_timer <= 0)
		{
			this.alpha = 0;
			_icon.alpha = 0;
			this.alive = false;
			
		}
		this.offset.y =  2*Math.sin(2.75 * _age);
		_icon.offset.y = 2*Math.sin(2.75 * _age);
	}
	
	public override function draw () : Void 
	{
		super.draw();
		_icon.draw();
	}
	
	private function LoadIcon(i : String):Void 
	{
		_icon = new FlxSprite();
		_icon.cameras = [GP.CameraMain];
		if ( i == "heart")
		{
				_icon.loadGraphic(AssetPaths.icon_heart__png, true, 16, 16);
				_icon.animation.add("idle", [0, 1], 3);
				_icon.animation.play("idle");
		}
		else if (i == "house")
		{
				_icon.loadGraphic(AssetPaths.icon_house__png, true, 16, 16);
				_icon.animation.add("idle", [0, 1, 2, 3], 6);
				_icon.animation.play("idle");
		}
		else if (i == "left")
		{
				_icon.loadGraphic(AssetPaths.icon_left__png, true, 16, 16);
				_icon.animation.add("idle", [2,0,1], 8);
				_icon.animation.play("idle");
		}
		else if (i == "apple")
		{
				_icon.loadGraphic(AssetPaths.item_apple__png, false, 16, 16);
				_icon.scale.set(0.5, 0.5);
		}
		else if (i == "branch")
		{
				_icon.loadGraphic(AssetPaths.item_branch__png, false, 16, 16);
				_icon.scale.set(0.5, 0.5);
		}
		else if (i == "leaf")
		{
				_icon.loadGraphic(AssetPaths.item_leaf__png, false, 16, 16);
				_icon.scale.set(0.5, 0.5);
		}
		else if (i == "stone")
		{
				_icon.loadGraphic(AssetPaths.item_stone__png, false, 16, 16);
				_icon.scale.set(0.5, 0.5);
		}
		else if (i == "fish")
		{
				_icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
		}
		else if (i == "flower")
		{
				_icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
		}
		else if (i == "egg")
		{
				_icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
		}
		else if (i == "excamation")
		{
				_icon.loadGraphic(AssetPaths.icon_house__png, false, 16, 16);
		}
		else if (i == "question")
		{
				_icon.loadGraphic(AssetPaths.icon_questionmark__png, true, 16, 16);
				_icon.animation.add("idle", [0, 1], 3);
				_icon.animation.play("idle");
				
		}
		else
		{
			throw "Speechbubble of type: "  + i + " no known!";
		}
	}
	
	
}