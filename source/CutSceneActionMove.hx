package ;

/**
 * ...
 * @author 
 */
class CutSceneActionMove extends CutSceneAction
{

	public var target : String;
	public var duration : Float;
	
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
	}
	
}