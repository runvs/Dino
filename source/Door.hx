package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
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
	
	private var dinoPos : FlxPoint = null;
	private var isOpening: Bool = false;
	
	private var doorName : String = "";
	
	public var leaver : LevelLeaver = null;
	
	public function new(?X:Float=0, ?Y:Float=0, n : String) 
	{
		super(X, Y);
		doorName = n;
		leaver = new Teleport(24, 24, 0.25, 0.75);
		var fileName = "assets/images/door_" + doorName +".png";
		this.loadGraphic(fileName, true, 48, 48);
		
		var NumberOfAnims : Int = Math.floor(pixels.width / 48);
		
		this.animation.add("hidden", [0]);
		this.animation.add("open1", [1 * NumberOfAnims], 30);
		this.animation.add("opening", [for (i in NumberOfAnims... (2 * NumberOfAnims)) i], 8, false);
		this.animation.add("open2", [2 * NumberOfAnims - 1]);
		this.animation.add("locked", [2*NumberOfAnims]);
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
		//CheckDinoDistance();
		SetTeleportStatus();
	}
	
	function SetTeleportStatus() 
	{
		if (leaver == null) return;
		
		if (status != 1)
		{
			leaver.Disable();
		}
		else
		{
			leaver.Enable();
		}
	}
	
	
	override public function draw():Void 
	{
		super.draw();
	}
	
	public function setDinoPosition(d:PlayableCharacter)
	{
		
		dinoPos = new FlxPoint(d.x, d.y);
		if (status == 1)
		{
			var dx : Float = dinoPos.x + 12 - (this.x + 24);
			var dy : Float = dinoPos.y + 16 - (this.y + 48);
			
			//trace(dx + " " + dy);
			if (Math.abs(dx) < 16 && Math.abs(dy) < 16)
			{
				if (!isOpening)
				{
					trace("door: " + doorName + " triggered");
					isOpening = true;
					this.animation.play("opening", false); 
				}
			}
		}
		
	}
	
	function CheckDinoDistance() 
	{
		
	}
	
	function CheckStatus() 
	{
		if (status == 0)
		{
			if (StoryManager.getBool(openKeyWord) == true)
			{
				SwitchHiddenToOpen();
			}
			if (StoryManager.getBool(closeKeyWord) == true)
			{
				SwitchOpenToClose();
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
			trace("unlock door");
			this.animation.play("open1");
		}
	}
	
	
	public function resetCamera ()
	{
		this.cameras = [GP.CameraMain];
	}
	
}