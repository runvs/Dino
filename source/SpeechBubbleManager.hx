package;
import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class SpeechBubbleManager extends FlxObject
{
	public var _speechbubbles : Array<SpeechBubble>;

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
	
	public function getSpeechBubble(n : String) : SpeechBubble
	{
		for (s in _speechbubbles)
		{
			if (s.name == n) return s;
		}
		return null;
	}
	
	
	public function addSpeechBubble (s : SpeechBubble)
	{
		if (s == null) return;
		// check if speechbubble is alread in the pool
		
		for (so in _speechbubbles)
		{
			if (s.name == so.name)
			{
				return;
			}
		}
		
		_speechbubbles.push(s);
	}
	
	public function lengt() 
	{
		return _speechbubbles.length;
	}

}