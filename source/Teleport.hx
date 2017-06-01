package;

/**
 * ...
 * @author 
 */
class Teleport extends LevelLeaver
{

	public var targetLevel : String = "";
	public var entryID : Int = 1;
	
	
	public function new(w: Int, h: Int) 
	{
		super(w, h);
	}
	
	public override function perform(stage : BasicState)
	{
		stage.LoadLevel("assets/data/" + targetLevel);
		stage.jumpToEntryPoint(entryID);
	}
	
}