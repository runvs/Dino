package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class SpeechBubble extends FlxSprite
{
	
	private var _parent : FlxSprite;

	private var _timer : Float = 0;
	
	private var _icon : FlxSprite;
	
	private var _age  : Float = 0;
	private var _isInFadeOut : Bool = false;
	
	public var name (default, null) : String;
	
	private var _endless : Bool = false;
	
	static private var DisappearTime : Float = -0.34;
	public var disappearing (default, null) :Bool = false;
	
	public function new(p: FlxSprite, iconName : String, duration : Float) 
	{
		super();
		_parent = p;
		_timer = duration;
		if (duration < 0)
		{
			_endless = true;
			_timer = 9000;
		}
		
		this.loadGraphic(AssetPaths.speechbubble__png, true, 16, 16);
		this.color = FlxColor.fromRGB(175, 175, 175, 175);
		this.cameras = [GP.CameraMain];
		LoadIcon(iconName);
		name = iconName;
		
		if (_timer > 0.42)
		{
			this.animation.add("pop", [0, 1, 2, 3], 16, false);
			this.animation.play("pop",true);
			_icon.alpha = 0;
			FlxTween.tween(_icon, { alpha:1 }, 0.15, {startDelay:0.25 } );
		}
		else
		{
			this.animation.add("idle", [3]);
			this.animation.play("idke", true);
		}
	}
	
	public override function update (elapsed : Float) : Void 
	{
		super.update(elapsed);
		_age += elapsed;
		this.setPosition(_parent.x + _parent.width/2 + 4, _parent.y- this.height/3*2 - 2);
		_icon.update(elapsed);
		_icon.setPosition(x, y - 1);
		if (!_endless)
		{
			_timer -= elapsed;
		}
		
		if (_timer <= 0)
		{
			if (!_isInFadeOut)
			{
				_isInFadeOut = true;
				FlxTween.tween(this, { alpha:0 }, 0.3);
				FlxTween.tween(this.scale, { x:1.5, y:1.5 }, 0.2, {startDelay:0.1 } );
				FlxTween.tween(this._icon, { alpha:0 }, 0.1);
			}
		}
		
		if (_timer <= DisappearTime)
		{
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
		else if (i == "up")
		{
				_icon.loadGraphic(AssetPaths.icon_up__png, true, 16, 16);
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
				_icon.loadGraphic(AssetPaths.item_fish__png, true, 16, 16);
				_icon.scale.set(0.75, 0.75);
				_icon.animation.add("idle", [0], 1, true);
				_icon.animation.play("idle");
				_icon.offset.set(-1, 4);
		}
		else if (i == "flower")
		{
				_icon.loadGraphic(AssetPaths.item_apple__png, false, 16, 16);
				_icon.scale.set(0.5, 0.5);
		}
		else if (i == "egg")
		{
				_icon.loadGraphic(AssetPaths.item_apple__png, false, 16, 16);
				_icon.scale.set(0.5, 0.5);
		}
		else if (i == "excamation")
		{
				_icon.loadGraphic(AssetPaths.item_apple__png, true, 16, 16);
				_icon.animation.add("idle", [0, 1, 2, 3], 3);
				_icon.animation.play("idle");
				//_icon.scale.set(0.5, 0.5);
		}
		else if (i == "question")
		{
				_icon.loadGraphic(AssetPaths.icon_questionmark__png, true, 16, 16);
				_icon.animation.add("idle", [0, 1], 3);
				_icon.animation.play("idle");
		}
		else if (i == "sleep")
		{
				_icon.loadGraphic(AssetPaths.icon_sleep__png, true, 16, 16);
				_icon.animation.add("idle", [0, 1], 3);
				_icon.animation.play("idle");
		}
		else
		{
			throw "Speechbubble of type: "  + i + " no known!";
		}
	}
	
	
	public function setIconAlpha (v : Float)
	{
		_icon.alpha = v;
	}
	
	public function MakeBubbleDisappear()
	{
		if (!disappearing)
		{
			disappearing = true;
			_endless = false;
			_timer = 0;
		}
	}
}