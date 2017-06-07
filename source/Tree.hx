package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Tree extends Blowable
{
	public var front : Bool = false;
	
	private var TreeID : Int = -1;
	
	var _particles : MyParticleSystem = null;
	var _particleTimer : Float = 0;
	var _leafSpawnArea : FlxRect;
	
	public function new(?X:Float=0, ?Y:Float=0, W : Int, H:Int, tID : Int = -1 ) 
	{
		super(X, Y);
		
		TreeID = tID;
	
		//loadGraphic(AssetPaths.grass__png, true, 8, 8, false);
		loadTreeGraphic(x, y, W, H);
		this.cameras = [GP.CameraMain];
	}
	
	function loadTreeGraphic(x:Float, y:Float, w:Int, h:Int) 
	{
		
		if (h == 32)
		{
			var r : Int = DeterministicRandom.int(0, 2);
			if (TreeID != -1)
			{
				r = TreeID;
			}
			
			if (r == 0)
			{
				loadGraphic(AssetPaths.tree_large_0__png, false, 32, 32);
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 9, y + 4, 14, 20);
			}
			else if (r == 1)
			{
				loadGraphic(AssetPaths.tree_large_1__png, false, 32, 32);
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 7, y + 7, 16, 21);
			}
			else if (r == 2)
			{
				loadGraphic(AssetPaths.tree_large_2__png, false, 16, 32);
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 2, y + 1, 10, 23);
			}
		}
		else if (h == 24)
		{
			y += 6;
			var r : Int = DeterministicRandom.int(0, 1);
			
			if (TreeID != -1)
			{
				r = TreeID;
			}
			
			if (r == 0)
			{
				loadGraphic(AssetPaths.tree_med_0__png, false, 16, 24);
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 3, y + 7, 9, 16);
			}
			else if (r == 1)
			{
				loadGraphic(AssetPaths.tree_med_1__png, false, 16, 24);
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 3, y + 7, 10, 10);
			}
		}
		else if (h == 16)
		{
			var r : Int = DeterministicRandom.int(0, 9);
			if (TreeID != -1)
			{
				r = TreeID;
			}
			var fn : String = "assets/images/trees/tree_small_" + Std.string(r) + ".png";
			loadGraphic(fn, false, 16, 16);
			
			if (r == 6)
			{
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 1, y + 1, 15, 8);
			}
			else if (r == 7)
			{
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 2, y + 1, 13, 11);	
			}
			else if (r == 8)
			{
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 4, y + 1, 11, 9);	
			}
			else if (r == 9)
			{
				_particles = new MyParticleSystem(20);
				_leafSpawnArea = new FlxRect(x + 4, y + 1, 11, 9);	
			}
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (_particles != null)
		{
			_particleTimer -= elapsed;
			if (_particleTimer <= 0)
			{
				SpawnLeafParticles();
				_particleTimer += FlxG.random.floatNormal(2.0,0.2);
			}
			_particles.update(elapsed);
		}
	}
	
	override public function blow():Void 
	{
		//if (!blown)
		//{
			//super.blow();
			//SpawnLeafParticles(3);
		//}
	}
	
	override public function draw():Void 
	{
		super.draw();
		if (_particles != null)
		{
			_particles.draw();
		}
	}
	
	public function resetCamera()
	{
		this.cameras =  [GP.CameraMain];
		
		if (_particles != null)
		{
			_particles.cameras = [GP.CameraMain];
			for (p in _particles)
			{
				p.cameras = [GP.CameraMain];
			}
		}
	
	}
	
	function SpawnLeafParticles( N : Int = 1):Void 
	{
		if (_particles == null)
		{
			return;
		}
		_particles.Spawn(N, function(s:FlxSprite) 
		{
			s.alive = true;
			
			var lx : Float = FlxG.random.float(_leafSpawnArea.left, _leafSpawnArea.right);
			var ly : Float = FlxG.random.float(_leafSpawnArea.top, _leafSpawnArea.bottom);
			var vy : Float = 6 + FlxG.random.floatNormal(0, 1);
			var vx : Float = -4 + FlxG.random.floatNormal(0, 2) - 2*(lx - _leafSpawnArea.right) / (_leafSpawnArea.right - _leafSpawnArea.left) ;
			var T : Float = (this.y + this.height - ly) / vy + 0.5;
			s.setPosition( lx , ly );
			var a : Float = FlxG.random.floatNormal(0.7, 0.2);
			if (a > 1 ) a = 1;
			if (a < 0.3 ) a = 0.35;
			s.alpha = a;
			
			FlxTween.tween(s, { alpha:0 }, T/8, { startDelay:  T/8*7, onComplete: function(t:FlxTween) : Void { s.alive = false; } } );
			s.velocity.set( vx, vy );
			s.angularVelocity = FlxG.random.floatNormal(40, 4);
		},
		function (s:FlxSprite)
		{	
			var f : Float = FlxG.random.float(0.6, 1);
			s.makeGraphic(1, 1, FlxColor.fromRGB(Std.int(64*f), Std.int(102*f), Std.int(64*f)));
			s.cameras = [GP.CameraMain];
		});
		
	}
	
}