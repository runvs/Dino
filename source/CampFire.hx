package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class CampFire extends ConditionalObject
{

	var _glow : GlowOverlay ;
	var _particles : MyParticleSystem;
	
	var t : Float = 0;
	var tparticles : Float = 0;
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super();
		x = X;
		y = Y + 2;
		this.loadGraphic(AssetPaths.campfire__png, true, 16, 16);
		this.animation.add("idle", [1, 2, 1, 3, 2, 1, 2, 3, 4, 3, 2, 1], 6, true);
		this.animation.play("idle");
		this.cameras = [GP.CameraMain];
		
		_glow = new GlowOverlay((x+this.width) * GP.CameraMain.zoom , (y+this.height) * GP.CameraMain.zoom, GP.CameraOverlay, 240, 1, 0.5);
		_glow.alpha = 0.25;
		_glow.color = FlxColor.fromRGB(173, 132, 56);
		
		_particles = new MyParticleSystem();
		_particles.cameras = [GP.CameraMain];
	}
	
	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		if (checkConditions())
		{
			_glow.update(elapsed);
			t += elapsed;
			tparticles -= elapsed;
			_glow.alpha = 0.075 + 0.1 * Math.abs(Math.cos(Math.sin(t * 2) + Math.sin(t * 0.7) + t * 2)) + 0.035 * Math.abs(Math.cos(1.5 * t)); 
			
			_particles.update(elapsed);
			if (tparticles <= 0)
			{
				tparticles += FlxG.random.float(0.2, 0.9);
				spawnFireCracles();
			}
		}
	}
	
	public override function draw()
	{
		if (checkConditions())
		{
			//trace("draw campfire");
			_particles.draw();
			super.draw();
			_glow.draw();
		}
	}
	
	function spawnFireCracles():Void 
	{
		_particles.Spawn(2, function(s:FlxSprite) 
		{
			s.alive = true;
			var T : Float = FlxG.random.float(0.75, 1.0);
			s.setPosition(FlxG.random.float(this.x + 4, this.x + 12) , y + height - 2 );
			//trace(s.x + " " + s.y);
			s.alpha = 0.95;
			FlxTween.tween(s, { alpha:0 }, T/4*3, { startDelay:  T/4, onComplete: function(t:FlxTween) : Void { s.alive = false; } } );
			s.velocity.set( 0, - 35 + FlxG.random.floatNormal(0, 3));
			
			
		},
		function (s:FlxSprite)
		{	
			s.makeGraphic(1, 1, FlxColor.fromRGB(173, 132, 56));
			s.cameras = [GP.CameraMain];
		});
		
	}
	
	public function resetCamera ()
	{
		_glow.cameras = [GP.CameraOverlay];
		_particles.cameras = [GP.CameraMain];
		for (p in _particles)
		{
			p.cameras = [GP.CameraMain];
		}
	}
	
}