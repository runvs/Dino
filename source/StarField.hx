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
			var s : FlxSprite = new FlxSprite( FlxG.random.float(-_padding, FlxG.width/_cam.zoom + _padding), FlxG.random.float(_padding, FlxG.height/_cam.zoom + _padding));
			s.cameras = [_cam];
			var r : Int = FlxG.random.int(175, 255);
			var g : Int = FlxG.random.int(175, 255);
			var b : Int = FlxG.random.int(175, 255);
			s.makeGraphic(2, 2, FlxColor.fromRGB(r, g, b, 255));
			s.scrollFactor.set(0.1, 0);
			add(s);
			
			_individualFrequencies.push(new FlxPoint(FlxG.random.floatNormal(1.0, 0.25), FlxG.random.float(0, Math.PI)));
			
			
			var gs : FlxSprite = new FlxSprite(s.x - glowSizeHalf, s.y - glowSizeHalf);
			
			gs.makeGraphic(Std.int(glowSizeHalf*2), Std.int(glowSizeHalf*2), FlxColor.fromRGB(r, g, b, 255), false);
		
			var distmax = Math.sqrt(glowSizeHalf*glowSizeHalf + glowSizeHalf*glowSizeHalf);
			
			for (i in 0... Std.int(gs.width))
			{
				for (j in 0... Std.int(gs.height))
				{
					var dx : Float = i - glowSizeHalf;
					var dy : Float = j - glowSizeHalf;
					
					var dist = Math.sqrt(dx * dx + dy * dy);
					var a = 1.0 - Math.pow(dist / glowSizeHalf , 1.0/5.0);
					gs.pixels.setPixel32(i, j, FlxColor.fromRGBFloat(1, 1, 1, a));
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