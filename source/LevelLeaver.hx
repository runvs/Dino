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
	
	private var _parts : Int = 0;
	
	public var LevelLeaverName (default, null) : String = "";
	
	private var leaverActive : Bool = true;
	
	public function new(w : Int, h : Int, l : Float, r : Float, n : String = "" ) 
	{
		super();
		LevelLeaverName = n;
		SpriteFunctions.createUpGlowArea(this, w, h, function(t) { return t; } , l, r);
		this.color = FlxColor.fromRGB(150, 144, 72);
		this.alpha = 0.75;
		
		if (w == 0 && h == 0)
			this.alpha = 0;
		
		_parts = Std.int(w / 10);
		if (_parts == 0) _parts = 1;
		
		
		_particles = new MyParticleSystem(w+1);
	}
	
	override public function draw():Void 
	{
		if (canBeUsed())
		{
			super.draw();
			_particles.draw();
		}
	}
	
	function spawnParticles():Void 
	{
		//trace("spawnparticles");
		_particles.Spawn(_parts, function(s:FlxSprite) 
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
		_particles.cameras = [GP.CameraMain];
		
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
		
		state.Fade2Black();
		var t : FlxTimer = new FlxTimer();
		t.start(1.0, function(t) { doPerform(state);  } );
		
	}
	
	public function Enable()
	{
		leaverActive = true;
	}
	public function Disable() 
	{
		leaverActive = false;
	}
	
	public function resetCamera()
	{
		_particles.cameras = [GP.CameraMain];
		for (p in _particles)
		{
			p.cameras = [GP.CameraMain];
		}
		this.cameras = [GP.CameraMain];
		
	}
	
	private function doPerform(state : BasicState)
	{
		// nothing to do in base class
	}
	
	public function canBeUsed() : Bool
	{
		return checkConditions() && leaverActive;
	}
}