package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Door extends FlxSprite
{
	public var status  (default, null) : Int = 0;	//0 hidden, 1 open, 2 locked
	public var openKeyWord (default, null) : String = "";
	public var closeKeyWord (default, null) : String  = "";
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		this.loadGraphic(AssetPaths.door_test__png, true, 48, 48);
		this.animation.add("hidden", [0]);
		this.animation.add("open", [1]);
		this.animation.add("locked", [2]);
		this.cameras = [GP.CameraMain];
	}
	
	public function setKeyWords(open : String, close : String)
	{
		openKeyWord = open;
		closeKeyWord = close;
		if (open == null) openKeyWord = "";
		if (close == null) closeKeyWord= "";
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		CheckStatus();
	}
	
	function CheckStatus() 
	{
		if (status == 0)
		{
			if (StoryManager.getBool(openKeyWord) == true)
			{
				SwitchHiddenToOpen();
			}
		}
		if ( status == 1)
		{
			if (StoryManager.getBool(closeKeyWord)  == true)
			{
				SwitchOpenToClose();
			}
		}
	}
	
	function SwitchOpenToClose() 
	{
		if (status == 1)
		{
			status = 2;
			this.animation.play("locked");
		}
	}
	
	function SwitchHiddenToOpen() 
	{
		if (status == 0)
		{
			status = 1;
			this.animation.play("open");
		}
	}
	
	
	public function resetCamera ()
	{
		this.cameras = [GP.CameraMain];
	}
	
}