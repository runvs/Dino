package;

/**
 * ...
 * @author 
 */
class Teleport extends LevelLeaver
{

	public var targetLevel : String = "";
	public var entryID : Int = 1;
	
	
	public function new(w: Int, h: Int, l : Float, r: Float) 
	{
		super(w, h, l, r);
	}
	
	private override function doPerform(stage : BasicState)
	{
		stage.LoadLevel("assets/data/" + targetLevel);
		stage.jumpToEntryPoint(entryID);
	}
	
}