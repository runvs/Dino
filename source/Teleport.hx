package;

/**
 * ...
 * @author 
 */
class Teleport extends LevelLeaver
{

	public var targetLevel : String = "";
	
	public function new() 
	{
		super();
	}
	
	public override function perform(stage : BasicState)
	{
		
		stage.LoadLevel(targetLevel);
	}
	
}