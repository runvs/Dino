package ;

/**
 * ...
 * @author 
 */
class CutSceneActionFade extends CutSceneAction
{

	public var targetAlpha: Float;
	public var duration : Float;
	
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
	}
	
}