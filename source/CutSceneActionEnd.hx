package ;

/**
 * ...
 * @author 
 */
class CutSceneActionEnd extends CutSceneAction
{

	public var next : String;
	
	public function new(a: String, n :String) 
	{
		super(a);
		next = n;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		
		trace("end action perform!");
	}
	
}