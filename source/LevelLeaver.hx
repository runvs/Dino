package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class LevelLeaver extends ConditionalObject
{
	public var type : String = "";
	
	private var _particles : MyParticleSystem;
	private var _particleTimer : Float = 0;
	
	public function new(w : Int, h : Int) 
	{
		super();
		SpriteFunctions.createUpGlowArea(this, w, h, function(t) { return t; } );
		this.alpha = 0.75;
		if (w == 0 && h == 0)
			this.alpha = 0;
		this.color = FlxColor.fromRGB(150, 144, 72);
		
		_particles = new MyParticleSystem(10);
	}
	
	override public function draw():Void 
	{
		if (checkConditions())
		{
			super.draw();
			_particles.draw();
		}
	}
	
	function spawnParticles():Void 
	{
		//trace("spawnparticles");
		_particles.Spawn(2, function(s:FlxSprite) 
		{
			s.alive = true;
			var T : Float = FlxG.random.float(0.55, 0.85);
			s.setPosition(FlxG.random.float(this.x, this.x + this.width) , y + height - 2 );
			//trace(s.x + " " + s.y);
			s.alpha = FlxG.random.float(0.55, 0.80);
			FlxTween.tween(s, { alpha:0 }, T/3, { startDelay:  T/3.0*2.0, onComplete: function(t:FlxTween) : Void { s.alive = false; } } );
			s.velocity.set( 0, - 15 + FlxG.random.floatNormal(0, 3));
		},
		function (s:FlxSprite)
		{	
			s.makeGraphic(1, 1, FlxColor.fromRGB(232, 224, 137));
			s.cameras = [GP.CameraMain];
		});
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		_particles.update(elapsed);
		_particleTimer -= elapsed;
		if ( _particleTimer <= 0)
		{
			_particleTimer += 0.3;
			spawnParticles();
		}
	}
	
	public function perform (state : BasicState)
	{
		
		FlxTween.tween(state._overlay, { alpha : 1 }, 0.75);
		
		var t : FlxTimer = new FlxTimer();
		t.start(0.8, function(t) { state._overlay.alpha = 0; doPerform(state);  } );
		
	}
	
	private function doPerform(state : BasicState)
	{
		// nothing to do in base class
	}
}