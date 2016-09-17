package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Flocks extends FlxSpriteGroup
{
	private var _globalVelocityX : Float= 0;
	private var _globalVelocityY : Float = 0;
	
	private var _timer : Float = 0;
	private var _cam : FlxCamera;

	private var _padding : Float = 10;
	
	// encoded as frequency and phase
	private var _individualVelocity:Array <FlxPoint>;
	
	public function new( f : FlxSprite-> Void, N : Int = 80, cam : FlxCamera, padding : Float = 10) 
	{
		super();
		_padding = padding;
		_individualVelocity = new Array<FlxPoint>();
		if ( cam != null)
		{
			_cam = cam;
		}
		else
		{
			_cam = FlxG.camera;
		}
		
		this.cameras = [_cam];
		for (i in 0 ... N)
		{
			var s : FlxSprite = new FlxSprite( FlxG.random.float(-_padding, FlxG.width/_cam.zoom + _padding), FlxG.random.float(_padding, FlxG.height/_cam.zoom + _padding));
			s.cameras = [_cam];
			f(s);
			add(s);
			
			_individualVelocity.push(new FlxPoint(FlxG.random.floatNormal(1.0, 0.25), FlxG.random.float(0,Math.PI)));
		}
	}
	
	
	
	public override function update (elapsed : Float)
	{
		
		
		super.update(elapsed);
		
		_timer  += elapsed;
		_globalVelocityX = 2* Math.sin( _timer * 0.5);
		_globalVelocityY = 2* Math.sin( _timer* 0.3 + 1.234);
		for (i in 0...this.length)
		{
			
			var s : FlxSprite = this.members[i];
			var vx : Float = _globalVelocityX + 4* Math.sin( _timer * _individualVelocity[i].x + _individualVelocity[i].y);
			var vy : Float = _globalVelocityY + 2* Math.sin( _timer * _individualVelocity[i].x + Math.PI/4 + _individualVelocity[i].y);
			s.velocity.set(vx,vy);
			
			var p : FlxPoint = new FlxPoint();
			
			var pret : FlxPoint = s.getScreenPosition(p, _cam);
			
			if (pret.x < -s.width - _padding) s.x += FlxG.width/_cam.zoom + s.width + _padding;
			if (pret.x > FlxG.width/_cam.zoom + _padding) s.x -= FlxG.width/_cam.zoom + s.width + _padding;
			
			if (pret.y < -s.height - _padding) s.y += FlxG.height/_cam.zoom + -_padding + s.height ;
			if (pret.y > FlxG.height/_cam.zoom + _padding) s.y -= FlxG.height/_cam.zoom + _padding + s.height;
		}
	}

	
}