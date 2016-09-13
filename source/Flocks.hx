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
	public var globalVelocityX : Float= 0;
	public var globalVelocityY : Float = 0;
	
	private var timer : Float = 0;
	private var _cam : FlxCamera;

	// encoded as frequency and phase
	private var individualVelocity:Array <FlxPoint>;
	
	public function new( f : FlxSprite-> Void, N : Int = 80, cam : FlxCamera) 
	{
		super();
		individualVelocity = new Array<FlxPoint>();
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
			var s : FlxSprite = new FlxSprite( FlxG.random.float(0, FlxG.width/_cam.zoom), FlxG.random.float(0, FlxG.height/_cam.zoom));
			s.cameras = [_cam];
			f(s);
			add(s);
			
			individualVelocity.push(new FlxPoint(FlxG.random.floatNormal(1.0, 0.25), FlxG.random.float(0,Math.PI)));
		}
	}
	
	public override function update (elapsed : Float)
	{
		
		
		super.update(elapsed);
		
		timer  += elapsed;
		globalVelocityX =  3* Math.sin( timer * 0.5);
		globalVelocityY = 3 + 1* Math.sin( timer* 0.3 + 1.234);
		for (i in 0...this.length)
		{
			
			var s : FlxSprite = this.members[i];
			var vx : Float = globalVelocityX + 4* Math.sin( timer * individualVelocity[i].x + individualVelocity[i].y);
			var vy : Float = globalVelocityY + 2* Math.sin( timer * individualVelocity[i].x + Math.PI/4 + individualVelocity[i].y);
			s.velocity.set(vx,vy);
			
			var p : FlxPoint = new FlxPoint();
			//trace("World " + s.x + " " + s.y);
			//trace("Screen " + s.getScreenPosition(p, _cam).x + " " + s.getScreenPosition(p, _cam).y);
			var pret : FlxPoint = s.getScreenPosition(p, _cam);
			
			if (pret.x < -s.width - 10) s.x += FlxG.width/_cam.zoom + s.width + 10;
			if (pret.x > FlxG.width/_cam.zoom + 10) s.x -= FlxG.width/_cam.zoom + s.width + 10;
			
			if (pret.y < -s.height - 10) s.y += FlxG.height/_cam.zoom + 10 + s.height ;
			if (pret.y > FlxG.height/_cam.zoom + 10) s.y -= FlxG.height/_cam.zoom + 10 + s.height;
		}
	}

	
}