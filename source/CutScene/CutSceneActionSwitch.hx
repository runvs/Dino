package;

/**
 * ...
 * @author 
 */
class CutSceneActionSwitch extends CutSceneAction
{

	private var id : String = "";
	private var newValue : Bool = true;

	public function new(a:String, pid : String, pv : Bool) 
	{
		super(a);
		id = pid;
		newValue = pv;
		
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		trace("switch action perform: Set " + id + " to " + Std.string(newValue) + "!");
		StoryManager.setBool(id, newValue);
	}
	
}