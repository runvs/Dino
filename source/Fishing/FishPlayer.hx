package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class FishPlayer extends FlxSprite
{

private var _state : FishState;
	public function new(s : FishState) 
	{
		super(s.playbg.x + s.playbg.width/2, s.playbg.y + s.playbg.height/2);
		
		_state = s;
		
		makeGraphic(16,16, FlxColor.BLUE);
		this.scrollFactor.set();
		this.cameras = [GP.CameraMain];
		
		this.acceleration.set ( -10, 0);
		this.drag.set(50, 50);
		
		this.maxVelocity.set(200, 200);
	}
	
	public override function update(elapsed: Float)
	{
		var accelFactor : Float = 120 / 1;
		this.maxVelocity.set(200* 1, 200* 1);
		
		
		// INPUT
		
		if (FlxG.keys.pressed.D)
		{
			this.acceleration.x = accelFactor;
		}
		else 
		{
			this.acceleration.x = -accelFactor;
		}
		
		if (FlxG.keys.pressed.W)
		{
			this.acceleration.y = -accelFactor/2;
		}
		else if (FlxG.keys.pressed.S)
		{
			this.acceleration.y = accelFactor/2;
		}
		else 
		{
			this.acceleration.y = 0;
		}
		
		
		// COLLISION
		if (this.x <= _state.playbg.x + _state.wallWidth )
		{
			x = _state.playbg.x + _state.wallWidth;
			this.velocity.x = - 0.5 * this.velocity.x;
			
			//FlxTween.color(_state.wl, 0.18, FlxColor.BLACK, FlxColor.WHITE, { type : FlxTween.PERSIST} );
		}
		if (this.y <= _state.playbg.y + _state.wallWidth ) 
		{
			y = _state.playbg.y + _state.wallWidth;
			this.velocity.y = - 0.5 * this.velocity.y;
			//FlxTween.color(_state.wt, 0.18, FlxColor.BLACK, FlxColor.WHITE, { type : FlxTween.PERSIST} );
		}
		
		if (this.x >= _state.playbg.x + _state.playbg.width - _state.wallWidth - this.width)
		{
			x = _state.playbg.x + _state.playbg.width - _state.wallWidth - this.width;
			this.velocity.x = - 0.5 * this.velocity.x;
			//FlxTween.color(_state.wr, 0.18, FlxColor.BLACK, FlxColor.WHITE, { type : FlxTween.PERSIST} );
		}
		if (this.y >= _state.playbg.y + _state.playbg.height - _state.wallWidth - this.height)
		{
			y = _state.playbg.y + _state.playbg.height - _state.wallWidth - this.height;
			this.velocity.y = - 0.5 * this.velocity.y;
			//FlxTween.color(_state.wb, 0.18, FlxColor.BLACK, FlxColor.WHITE, { type : FlxTween.PERSIST} );
		}
		
		super.update(elapsed);
	}
		
}