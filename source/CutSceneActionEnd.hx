package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class CutSceneActionEnd extends CutSceneAction
{

	var what : String;
	var next : String;
	
	public function new(a: String, w: String, n :String) 
	{
		super(a);
		what = w;
		next = n;
	}
	
	public override function perform(scene : CutSceneState)
	{
		super.perform(scene);
		trace("end action perform! " + next);
		
		if ( what == "play")
		{
			FlxG.switchState(new PlayState());
		}
		else if (what == "cut")
		{
			FlxG.switchState(new CutSceneState(next));
		}
	}
	
}