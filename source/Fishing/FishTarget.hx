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
	
	private var _overlay : FlxSprite;
	
	private var _darkOverlay : FlxSprite;
	
	
	private var _jumpTimer : Float = 0;
	private var _jumpTimerMax : Float;

	private var _playBG : FlxSprite;
	private var _wallWidth : Float;
	
	public function new( playBG : FlxSprite, wallWidth : Float) 
	{
		super(0,0);
		_playBG = playBG;
		_wallWidth = wallWidth;
		
		resetToNewPosition();
		
		//makeGraphic(32, 32, FlxColor.TRANSPARENT, true);
		//this.drawCircle(16, 16, 16, Palette.primary4());
		this.loadGraphic(AssetPaths.item_fish__png, false, 16, 16);
		this.scrollFactor.set();
		this.cameras = [GP.CameraMain];
		
		_darkOverlay = new FlxSprite();
		
		_darkOverlay.makeGraphic(16, 16, FlxColor.BLACK, true);
		_darkOverlay.scrollFactor.set();
		_darkOverlay.cameras = [GP.CameraMain];
		
		
		_overlay = new FlxSprite();
		_overlay.makeGraphic(16, 16, FlxColor.WHITE, true);
		_overlay.alpha = 0;
		_overlay.scrollFactor.set();
		_overlay.cameras = [GP.CameraMain];
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
		_overlay.alpha =v ;
		_overlay.scale.set(v, v);
		_overlay.setPosition(x, y);
		
		v = _jumpTimer / _jumpTimerMax;
		_darkOverlay.scale.set(v, v);
		_darkOverlay.setPosition(x, y);
		
		
		
	}
	
	public function resetToNewPosition() 
	{
		this.setPosition(FlxG.random.float(_playBG.x + _wallWidth , _playBG.x + _playBG.width - _wallWidth - this.width), 
						 FlxG.random.float(_playBG.y + _wallWidth , _playBG.y + _playBG.height - _wallWidth - this.height));
		this.timer = 0;
		
		this.overlap = false;
		this._jumpTimer = 0;
		_jumpTimerMax = FlxG.random.floatNormal(10, 1.5);
	}
	
	public override function draw()
	{
		super.draw();
		_darkOverlay.draw();
		_overlay.draw();
	}
	
}