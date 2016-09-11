package ;

/**
 * ...
 * @author 
 */
class CutSceneActionSpeak extends CutSceneAction
{

	public var icon : String;
	public var duration : Float;
	
	public function new(a: String, i :String, d: Float) 
	{
		super(a);
		icon = i;
		duration = d;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		
		trace("speak action perform!");
	}
	
}