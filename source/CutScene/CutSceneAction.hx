package ;

/**
 * ...
 * @author 
 */
class CutSceneAction
{
	
	public var timer : Float = 0;
	
	public var performed : Bool = false;
	public var actor : String = "";
	
	public var trigger : Bool = false;
	
	public var duration : Float = 0;
	
	
	public function new (a : String)
	{
		actor = a;
	}
	
	public function perform (scene : CutSceneState)
	{
		performed = true;
	}
	
	public function update(elapsed : Float )
	{
		timer -= elapsed;
		
		if (timer <= 0)
		{
			trigger = true;
		}
		
	}
}