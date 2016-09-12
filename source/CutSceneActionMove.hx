package ;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class CutSceneActionMove extends CutSceneAction
{

	var target : String;
	var duration : Float;
	
	public function new(a: String, t :String, d: Float) 
	{
		super(a);
		target = t;
		duration = d;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		trace("move action perform!");
		
		var ac : CutSceneActor = scene.getActor(this.actor);
		var p : PositionData = scene.getPosition(this.target);
		if (ac != null && p != null)
		{
			// that is a dumb way of doing it
			//FlxTween.tween(ac, { x: p.x, y: p.y }, duration);
			
			if (duration > 0)
			{
				var vx : Float = (p.x - ac.x) / duration;
				var vy : Float = (p.y - ac.y) / duration;
				ac.velocity.x = vx;
				ac.velocity.y = vy;
				
				var t : FlxTimer= new FlxTimer();
				t.start(duration, function (t) { ac.velocity.x = 0; ac.velocity.y = 0; } );
			}
			else
			{
				ac.setPosition(p.x, p.y);
			}
		}
	}
	
}