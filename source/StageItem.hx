package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;


/**
 * ...
 * @author 
 */
class StageItem extends FlxSpriteGroup
{	
	public var name : String; 
	public var stage (default, null) : Int = 0;
	public var episode (default, null): Int = 0;
	public var stageToStartFrom (default, null) : Bool = true;
	private var _type : String = "";
	private var actor : String = "";
	private var _level : String = "";
	private var _iconName : String = "";
	private var _icon : FlxSprite;
	private var _nameText : FlxText;
	
	
	private var _gather : Array<String>;
	private var _storysettings:Array<String>;
	
	public var gridXPos : Int = 0;
	
	public function new(n: String, s : Int, e : Int, t : String, a:String, l : String, i: String) 
	{
		super();
		
		name = n;
		stage = s;
		episode = e;
		_type = t;
		actor = a;
		_level = l;
		_gather = new Array<String>();
		_iconName = i;
		if (_iconName == "")
		{
			stageToStartFrom = false;
		}
		else
		{
			_icon = new FlxSprite(GP.MenuItemsOffsetX + gridXPos * (GP.MenuItemsSize + GP.MenuItemsPadding), 
			GP.MenuItemsOffsetY + (GP.MenuItemsSize + GP.MenuItemsPadding) * stage);
			_icon.loadGraphic("assets/images/TN_" + _iconName + ".png", false, 24, 24);
			
			
			
			add(_icon);
		}
		this.cameras = [GP.CameraMain ];
		
		_nameText = new FlxText(
		GP.MenuItemsOffsetX + episode * (GP.MenuItemsSize + GP.MenuItemsPadding), 
		GP.MenuItemsOffsetY + (GP.MenuItemsSize + GP.MenuItemsPadding) * stage, 
		GP.MenuItemsSize, name, 2);
		_nameText.cameras = [GP.CameraMain];
		//add(_nameText);
		
	}
	

	
	public function SetGatherItems (arr: Array<String>)
	{
		if (arr != null)
			_gather = arr;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		_icon.setPosition(GP.MenuItemsOffsetX + gridXPos * (GP.MenuItemsSize + GP.MenuItemsPadding), 
		GP.MenuItemsOffsetY + (GP.MenuItemsSize + GP.MenuItemsPadding) * stage);
	}
	
	public function setRequirements(requirements:Array<String>) 
	{
		
	}
	
	public function setStorySettings(s:Array<String>) 
	{
		if ( s == null) 
		throw "ERROR: Storysettings may not be null!";
		
		_storysettings = s;
		
	}
	
	public function startStage()
	{
		MyInput.reset();
		trace("StartStage, number of cameras: " + FlxG.cameras.list.length);
		if (_type == "play")
		{
			FlxG.switchState(new PlayState(_level, actor));
		}
		else if (_type == "cut")
		{
			FlxG.switchState(new CutSceneState(_level));
		}
		else if (_type == "gather")
		{
			var gs : GatherState = new GatherState(_level, actor);
			gs.createCollectibleList(_gather);
			FlxG.switchState(gs);
		}
		else if (_type == "fishing")
		{
			var fs : FishState = new FishState();
			FlxG.switchState(fs);
		}
		else if (_type == "end")
		{
			FlxG.switchState(new EndState());
		}
		else
		{
			throw "ERROR: Unknown Type in StageItem: " + _type;
		}
		
		for (s in _storysettings)
		{
			StoryManager.setBool(s, true);
		}
	}

	public static function compareEpisodeNumber (s1 : StageItem, s2 : StageItem) : Int 
	{
		return s1.episode - s2.episode;
	}
	
	
}