package;
import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class SpeechBubbleManager extends FlxObject
{
	var _speechbubbles : Array<SpeechBubble>;

	public function new() 
	{
		super(0, 0, 0, 0);
		_speechbubbles = new Array<SpeechBubble>();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		for (s in _speechbubbles)
		{
			s.update(elapsed);
		}
		clearBubbles();
	}
	
	override public function draw():Void 
	{
		//super.draw();
		for (s in _speechbubbles)
		{
			s.draw();
		}
	}
	
	function clearBubbles() 
	{
		var newlist = new Array<SpeechBubble>();
		for (s in _speechbubbles) { if (s.alive) newlist.push(s); }
		_speechbubbles = newlist;
	}
	
	public function addSpeechBubble (s : SpeechBubble)
	{
		_speechbubbles.push(s);
	}

}