package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Collectible extends ConditionalObject
{
	public var _storyManagerID (default, null) : String;
	
	public var _started : Bool = false;
	
	private var _glow : GlowOverlay;
	private var _particles : MyParticleSystem;
	private var _particleTimer : Float = 0;
	
	private var _teleport : Teleport = null;
	
	
	public function new(n:String) 
	{
		super();
		name = n;
		_storyManagerID = "has_" + name;
		
		LoadSprites(this, name);
		
		_glow = new GlowOverlay((x+this.width) * GP.CameraMain.zoom , (y+this.height) * GP.CameraMain.zoom, GP.CameraOverlay, 120, 1, 0.5);
		_glow.alpha = 0.4;
		
		_particles = new MyParticleSystem(30);
	}
	
	
	public function setTeleport(level:String, entryID: Int)
	{
		_teleport = new Teleport(0,0,0,0);
		_teleport.targetLevel = level;
		_teleport.entryID = entryID;
	}
	
	public function collectMe(stage:BasicState)
	{
		if (alive)
		{
			this.alive = false;
			trace("collecting "+_storyManagerID );
			StoryManager.setBool(_storyManagerID, true);
			
			if (_teleport != null)
			{
				_teleport.perform(stage);
			}
		}
	}
	
	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		
		_glow.setPosition(( x + 16) * GP.CameraMain.zoom ,(y + 16)* GP.CameraMain.zoom );
		_glow.update(elapsed);
		
		_particles.update(elapsed);
		_particleTimer -= elapsed;
		if (_particleTimer <= 0)
		{
			_particleTimer += 0.15;
			spawnParticles();
		}
		
		if (!_started)
		{
			_started = true;
			y += 1;
			FlxTween.tween(this, { y:y - 4 }, 1.75, { type:FlxTween.PINGPONG, ease : FlxEase.sineInOut } );
		}
		
	}
	
	override public function draw():Void 
	{
		//trace("draw");

		if (checkConditions())
		{
			_particles.draw();
			
			_glow.draw(); 
			super.draw();
		}
		
	}
	
	public static function LoadSprites(spr : FlxSprite, name : String):Void 
	{
		if (name == "leaf")
		{
			spr.loadGraphic(AssetPaths.item_leaf__png, false, 16, 16, true);
		}
		else if (name == "stone")
		{
			spr.loadGraphic(AssetPaths.item_stone__png, false, 16, 16, true);
		}
		else if (name == "branch")
		{
			spr.loadGraphic(AssetPaths.item_branch__png, false, 16, 16, true);
		}
		else
		{
			spr.makeGraphic(16, 16, FlxColor.BLUE);
			spr.alpha = 0.5;
		}
		spr.cameras = [GP.CameraMain];
		spr.scale.set(0.5, 0.5);
	}
	
	
	public function resetCamera()
	{
		_glow.cameras = [GP.CameraOverlay];
		//_particles.cameras = [GP.CameraMain];
	}
	
	function spawnParticles():Void 
	{
		//trace("spawnparticles");
		_particles.Spawn(1, function(s:FlxSprite) 
		{
			s.alive = true;
			var T : Float = FlxG.random.float(0.55, 0.65);
			s.setPosition(x + this.width/2, y + this.height /2 );
			//trace(s.x + " " + s.y);
			s.alpha = FlxG.random.float(0.45, 0.60);
			var v : Float = FlxG.random.float(0, Math.PI * 2);
			var t : Float = FlxG.random.float(9, 14);
			s.velocity.set( Math.cos(v) * t , Math.sin(v) * t);
			
			FlxTween.tween(s, { alpha:0 }, T/3, { startDelay:  T/3.0*2.0, onComplete: function(t:FlxTween) : Void { s.alive = false; } } );
			
		},
		function (s:FlxSprite)
		{	
			s.makeGraphic(1, 1, FlxColor.WHITE);
			s.cameras = [GP.CameraMain];
		});
		
	}
	
}