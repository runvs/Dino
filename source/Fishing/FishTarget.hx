package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class FishTarget extends FlxSprite
{

	public var timer : Float = 0;
	
	public var maxTimer : Float = GP.FishingTimerMax;
	
	public var overlap : Bool = false;
	

	
	private var _jumpTimer : Float = 0;
	private var _jumpTimerMax : Float;

	private var _playBG : FlxSprite;
	private var _wallWidth : Float;

	// what type of fish this is (needed for list of caught fish in FishState)
	public var _fishtype : Int = 0;
	private static var _fishTypeMax : Int = 1;
	
	public function new( playBG : FlxSprite, wallWidth : Float) 
	{
		super(0,0);
		_playBG = playBG;
		_wallWidth = wallWidth;
		
		
		
		
		this.loadGraphic(AssetPaths.item_fish__png, true, 16, 16);
		for (i in 0 ... _fishTypeMax +1)
		{
			this.animation.add(Std.string(i), [i]);
		}
		resetToNewPosition();
		
		
		this.scrollFactor.set();
		this.cameras = [GP.CameraMain];
	}
	
	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		
		_jumpTimer += elapsed;
		if (_jumpTimer >= _jumpTimerMax)
		{
			resetToNewPosition();
		}
			
		if (overlap) 
			timer += elapsed;
		else 
			timer -= elapsed / 4;
			
		if (timer <= 0 )
		{	
			timer= 0;
		}
		
		var v : Float = timer / maxTimer;
		var aval = 0.2 + 0.8 * Math.pow(v, 1.5);
		this.alpha = aval;
		
		v = _jumpTimer / _jumpTimerMax;
		
		var sval = 0.15 + 0.85 * (v < 0.5 ? v * 2 : (1 - v)*2);
		if (sval < 0) sval = 0;
		if (sval > 1.0) sval = 1.0;
		//trace( _jumpTimer + " " + _jumpTimerMax + " " + v + " " + sval);
		this.scale.set(sval, sval);
		
			
		
		CollideWithWalls();
	}
	
	public function resetToNewPosition() 
	{
		
		var vx : Float = FlxG.random.floatNormal(0, 8);
		var vy : Float = FlxG.random.floatNormal(0, 8);
		this.velocity.set( vx, vy);
		
		this.setPosition(FlxG.random.float(_playBG.x + _wallWidth , _playBG.x + _playBG.width - _wallWidth - this.width), 
						 FlxG.random.float(_playBG.y + _wallWidth , _playBG.y + _playBG.height - _wallWidth - this.height));
		this.timer = 0;
		
		this.overlap = false;
		this._jumpTimer = 0;
		_jumpTimerMax = FlxG.random.floatNormal(10, 1.5);
		_fishtype = FlxG.random.int(0, _fishTypeMax);
		this.animation.play(Std.string(_fishtype));
		this.scale.set(0.15, 0.15);
		this.alpha = 0.2;
	}
	
	public override function draw()
	{
		super.draw();
	}
	
	function CollideWithWalls():Void 
	{
		if (this.x < _playBG.x + _wallWidth )
		{
			this.x = _playBG.x + _wallWidth;
			this.velocity.x = - this.velocity.x;
		}
		
		if (this.y < _playBG.y + _wallWidth )
		{
			this.y = _playBG.y + _wallWidth;
			this.velocity.y = - this.velocity.y;
		}
		
		if (this.x > _playBG.x + _playBG.width - this.width - _wallWidth)
		{
			this.x > _playBG.x + _playBG.width - this.width - _wallWidth;
			this.velocity.x = - this.velocity.x;
		}
		if (this.y > _playBG.y + _playBG.height- this.height - _wallWidth)
		{
			this.y > _playBG.y + _playBG.height - this.height - _wallWidth;
			this.velocity.y = - this.velocity.y;
		}
	}
}