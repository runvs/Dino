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
class ScreenWrappingSpriteGroup extends FlxSpriteGroup
{
	
	private var _cam : FlxCamera;
	private var _padding : Float = 10;
	
	public function new( cam : FlxCamera, padding : Float = 10) 
	{
		super();
		_padding = padding;
		
		if ( cam != null)
		{
			_cam = cam;
		}
		else
		{
			_cam = FlxG.camera;
		}
		
		this.cameras = [_cam];
	}

	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		wrapCoordinates();
	}
	
	function wrapCoordinates():Void 
	{
		for (i in 0...this.length)
		{
			var s : FlxSprite = this.members[i];
			wrapSpriteCoordinates(s);
		}
	}
	
	public function wrapAndDo (s : FlxSprite, horizontal : Bool = false )
	{
		// nothing to do here
	}
	
	function wrapSpriteCoordinates(s:FlxSprite)
	{
		var p : FlxPoint = new FlxPoint();
		var pret : FlxPoint = s.getScreenPosition(p, _cam);
		
		if (pret.x < -s.width - _padding) 
		{
			s.x += _cam.width + s.width * s.scale.x + _padding;
			wrapAndDo(s, true);
		}
		if (pret.x > _cam.width + _padding)
		{
			s.x -= _cam.width + s.width * s.scale.x + _padding;
			wrapAndDo(s, true);
		}
		
		if (pret.y < -s.height - _padding)
		{
			s.y += _cam.height + -_padding + s.height * s.scale.y ;
			wrapAndDo(s);
		}
		if (pret.y > _cam.height + _padding)
		{
			s.y -= _cam.height + _padding + s.height * s.scale.y;
			wrapAndDo(s);
		}
	}
	
}