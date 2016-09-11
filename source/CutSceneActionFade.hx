package ;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author 
 */
class CutSceneActionFade extends CutSceneAction
{

	var targetAlpha: Float;
	var duration : Float;
	
	public function new(a: String, t :Float, d: Float) 
	{
		super(a);
		targetAlpha = t;
		duration = d;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		trace("fade action perform!");
		
		var ac : CutSceneActor = scene.getActor(this.actor);
		
		if (ac != null)
		{
			FlxTween.tween(ac, { alpha:targetAlpha }, duration);
		}
	}
	
}