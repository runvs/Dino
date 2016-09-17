package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

/**
 * ...
 * @author 
 */
class StarField extends ScreenWrappingSpriteGroup
{

	private var _timer : Float = 0;
	// encoded as frequency and phase
	private var _individualFrequencies : Array<FlxPoint>;
	
	private var _glow : Array<FlxSprite>;
	
	var glowSizeHalf : Float = 9;
	
	
	public function new(cam:FlxCamera, padding:Float=10) 
	{
		super(cam, padding);
		
		_individualFrequencies = new Array<FlxPoint>();
		
		_glow = new Array<FlxSprite>();
		
		
		for (i in 0 ... 35)
		{
			var spr : FlxSprite = new FlxSprite( FlxG.random.float(-_padding, FlxG.width/_cam.zoom + _padding), FlxG.random.float(_padding, FlxG.height/_cam.zoom + _padding));
			spr.cameras = [_cam];
			var h : Float = FlxG.random.float(0, 360);
			var s : Float = 0.3;
			var b : Float = 0.9;
			spr.makeGraphic(2, 2, FlxColor.fromHSB(h, s*s, b, 1),true);
			spr.scrollFactor.set(0.1, 0);
			add(spr);
			
			_individualFrequencies.push(new FlxPoint(FlxG.random.floatNormal(1.0, 0.25), FlxG.random.float(0, Math.PI)));
			
			
			var gs : FlxSprite = new FlxSprite(spr.x , spr.y );
			gs.offset.set(glowSizeHalf, glowSizeHalf);
			gs.makeGraphic(Std.int(glowSizeHalf*2), Std.int(glowSizeHalf*2), FlxColor.TRANSPARENT, true);
		
			var distmax = Math.sqrt(glowSizeHalf*glowSizeHalf + glowSizeHalf*glowSizeHalf);
			
			for (i in 0... Std.int(gs.width))
			{
				for (j in 0... Std.int(gs.height))
				{
					var dx : Float = i - glowSizeHalf;
					var dy : Float = j - glowSizeHalf;
					
					var dist = Math.sqrt(dx * dx + dy * dy);
					var a = 1.0 - Math.pow(dist / glowSizeHalf , 1.0/5.0);
					gs.pixels.setPixel32(i, j, FlxColor.fromHSB(h, s,b , a));
				}
			}
			gs.cameras = [_cam];
			gs.scrollFactor.set(0.1, 0);
			_glow.push(gs);
		}
	}
	
	public override function update ( elapsed : Float)  : Void 
	{
		super.update(elapsed);
		_timer += elapsed;
		
		for (i in 0...members.length)
		{
			var s = members[i];
			var v : Float = 1.0 - Math.pow(Math.sin( _timer * _individualFrequencies[i].x + _individualFrequencies[i].y), 128);
			s.alpha = v;
			
			var gs = _glow[i];
			wrapSpriteCoordinates(gs);
			gs.alpha = v * 0.5;
		}
	}
	
	public override function draw()
	{
		super.draw();
		for (s in _glow)
		{
			s.draw();
		}
	}
	
	
}