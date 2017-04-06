package ;

/**
 * ...
 * @author 
 */
class CutSceneActionAnimation extends CutSceneAction
{

	var animation : String;
	var force : Bool;
	
	public function new(a: String, anim :String, f: Bool) 
	{
		super(a);
		animation = anim;
		force = f;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		trace("animation action perform: " + animation + "!");
		var ac : CutSceneActor = scene.getActor(this.actor);
		if (ac != null)
		{
			ac.animation.play(this.animation, this.force);
		}
		
		
	}
	
}