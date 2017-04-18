package ;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author 
 */
class CutSceneActionFade extends CutSceneAction
{

	var targetAlpha: Float;
	
	public function new(a: String, t :Float, d: Float) 
	{
		super(a);
		targetAlpha = t;
		duration = d;
		timer = 0;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		trace("fade action perform!");
		
		if (actor == "overlay" )
		{
			FlxTween.tween(scene._overlay2, { alpha:targetAlpha }, duration);
		}
		else
		{	
			var ac : CutSceneActor = scene.getActor(this.actor);
			
			if (ac != null)
			{
				FlxTween.tween(ac, { alpha:targetAlpha }, duration);	
			}
		}
	}
	
}