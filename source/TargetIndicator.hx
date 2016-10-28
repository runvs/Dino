package;

import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxVerticalAlign;

using MathExtender;

/**
 * ...
 * @author 
 */
class TargetIndicator extends FlxSprite
{

	private var _player : PlayableCharacter;
	private var _target : ConditionalObject = null;
	
	public function new(pl : PlayableCharacter) 
	{
		super();
		_player = pl;
		
		this.makeGraphic(64, 12, FlxColor.GRAY);
		this.cameras = [GP.CameraOverlay];
		this.centerOrigin();
	}
	
	public override function update(elapsed:Float) 
	{
		super.update(elapsed);
	
		if (_target != null)
		{
			var dirX = (_target.x + _target.width/2) - (_player.x + _player.width/2);
			var dirY = (_target.y + _target.height/2)- (_player.y + _player.height/2);
			var vecDir : FlxVector = new FlxVector(dirX, dirY);
			vecDir.normalize();
			this.angle = vecDir.radians.Rad2Deg();
			
			x = _player.tracer.x + _player.tracer.width/2 + vecDir.x * 100;
			y = _player.tracer.y + _player.tracer.height/2 + vecDir.y * 100;
		}
	}
	
	public override function draw ()
	{
		if (_target != null)
		{
			super.draw();
		}
	}
	public function SetTarget (ta : ConditionalObject)
	{
		//if (ta != null)
		{
			_target = ta;
		}
	}
}