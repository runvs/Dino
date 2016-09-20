package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;


/**
 * ...
 * @author 
 */
class StageItem extends FlxSpriteGroup
{
	private var _name : String; 
	private var _stage : Int = 0;
	private var _episode : Int = 0;
	
	private var _nameText : FlxText;
	
	public function new(n: String, s : Int, e : Int) 
	{
		super();
		
		_name = n;
		_stage = s;
		_episode = e;
		this.cameras = [GP.CameraMain ];
		
		_nameText = new FlxText(16 + _episode * 128, 16 + 16*_stage, 128, _name, 8);
		_nameText.cameras = [GP.CameraMain];
		add(_nameText);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
	}
	
	public function setRequirements(requirements:Array<String>) 
	{
		
	}
	
	public function setStorySettings(storysettings:Array<String>) 
	{
		
	}
	
}