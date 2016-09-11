package ;

/**
 * ...
 * @author 
 */
class CutSceneActionAnimation extends CutSceneAction
{

	public var animation : String;
	public var force : Bool;
	
	public function new(a: String, anim :String, f: Bool) 
	{
		super(a);
		animation = anim;
		force = f;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		
		trace("animation action perform!");
	}
	
}