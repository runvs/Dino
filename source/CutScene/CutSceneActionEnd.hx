package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class CutSceneActionEnd extends CutSceneAction
{
	var _name : String = "";
	public function new(a: String, n :String) 
	{
		super(a);
		_name = n;
		//_stage = new StageItem("", 0, 0, w, n);
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		trace("end action perform! " + _name);
		
		StageInfo.getStage(_name).startStage();
	}
	
}