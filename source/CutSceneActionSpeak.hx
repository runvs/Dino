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
		
		var ac : CutSceneActor = scene.getActor(this.actor);
		if (ac != null)
		{
			var s : SpeechBubble = new SpeechBubble(ac, icon, duration);
			scene.addSpeechBubble(s);
		}
	}
	
}