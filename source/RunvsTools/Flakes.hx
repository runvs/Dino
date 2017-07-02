package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Flakes extends ScreenWrappingSpriteGroup
{

	// encoded as frequency and phase
	var _individualVelocity:Array <FlxPoint>;
	var _individualTimer:Array <Float>;
	
	private var visibleTime : Float = GP.WorldFlakesVisibleTime;
	private var invisibleTime : Float = GP.WorldFlakesInvisibleTime;
	private var zoom : Float = GP.CameraMain.zoom;
	
	private var _globalVelocityX : Float= 0;
	private var _globalVelocityY : Float = 0;
	
	var _timer : Float = 0;
	
	
	public function new(cam:FlxCamera, padding:Float=10, N : Int = 25) 
	{
		super(cam, padding);
		_individualVelocity = new Array<FlxPoint>();
		_individualTimer = new Array<Float>();
		this.scrollFactor.set(1.1, 1.1);
		for (i in 0 ... N)
		{
			var s : FlxSprite = new FlxSprite( FlxG.random.float(-_padding, _cam.width + _padding), FlxG.random.float(-_padding, _cam.height + _padding));
			s.cameras = [_cam];
			s.makeGraphic(Std.int(zoom), Std.int(zoom), FlxColor.fromRGB(175, 175, 175, 150));
			s.scrollFactor.set(1.1, 1.1);
			add(s);
			_individualTimer.push(FlxG.random.float( - invisibleTime, visibleTime));
			_individualVelocity.push(new FlxPoint(FlxG.random.floatNormal(1.0, 0.25), FlxG.random.float(0,Math.PI)));
		}	
	}
	
	public override function update (elapsed : Float ): Void 
	{
		super.update(elapsed);
		_timer  += elapsed;
		_globalVelocityX = 2* Math.sin( _timer * 0.5);	
		_globalVelocityY = 2* Math.sin( _timer* 0.3 + 1.234);
		
		for (i in 0...members.length)
		{
			var s = members[i];
			var vx : Float = _globalVelocityX + 4* Math.sin( _timer * _individualVelocity[i].x + _individualVelocity[i].y);
			var vy : Float = _globalVelocityY + 2 * Math.sin( _timer * _individualVelocity[i].x + Math.PI / 4 + _individualVelocity[i].y);
			s.velocity.set(vx * 4.0, vy * 4.0);
			
			
			if (_individualTimer[i] > 0)
			{
				_individualTimer[i] -= elapsed;
				if (_individualTimer[i] <= 0)
				{
					//s.alpha = 0;
					FlxTween.tween(s, { alpha : 0 }, 0.25 );
					_individualTimer[i] = FlxG.random.float( -invisibleTime, -invisibleTime/2);
				}
			}
			else
			{
				_individualTimer[i] += elapsed;
				if (_individualTimer[i] > 0)
				{
					//s.alpha = 1;
					FlxTween.tween(s, { alpha : 1 }, 0.25 );
					_individualTimer[i] = FlxG.random.float(visibleTime/2, visibleTime);
				}
			}
		}
		
	}
	
}