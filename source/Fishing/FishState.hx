package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class FishState extends BasicState
{
	
	public var playbg : FlxSprite;
	public var wallWidth : Int = 5;
	private var _walls : FlxSpriteGroup;
	private var _targets : FlxTypedGroup<FishTarget>;
	private var _player : FishPlayer;
	
	private var Score : Int ;
	
	
	public function new() 
	{
		super();
		_levelName = "assets/data/fishing.tmx";
	}
	
	override public function create():Void
	{
		super.create();
		LoadLevel(_levelName);
		
		Score = 0;
		
		///////////////////////////////////////
		//// Creating Playing Background //////
		///////////////////////////////////////
		playbg = new FlxSprite(25, 15);
		playbg.makeGraphic(150, 80, FlxColor.BLACK);
		playbg.scrollFactor.set();
		playbg.cameras = [GP.CameraMain];
		
		///////////////////////////////////////
		//// Creating Walls ///////////////////
		///////////////////////////////////////
		_walls = new FlxSpriteGroup();
		_walls.scrollFactor.set();
		_walls._cameras = [GP.CameraMain];
		
		var wallColor : FlxColor = FlxColor.WHITE;
		
		var wl : FlxSprite = new FlxSprite(playbg.x, playbg.y);
		wl.makeGraphic(wallWidth, Std.int(playbg.height), wallColor);
		wl.scrollFactor.set();
		wl.cameras = [GP.CameraMain];
		_walls.add(wl);
		
		var wt : FlxSprite = new FlxSprite(playbg.x + wallWidth, playbg.y);
		wt.makeGraphic(Std.int(playbg.width - 2 * wallWidth), wallWidth, wallColor);
		wt.scrollFactor.set();
		wt.cameras = [GP.CameraMain];
		_walls.add(wt);
		
		var wr : FlxSprite = new FlxSprite(playbg.x + playbg.width - wallWidth, playbg.y);
		wr.makeGraphic(wallWidth, Std.int(playbg.height), wallColor);
		wr.scrollFactor.set();
		wr.cameras = [GP.CameraMain];
		_walls.add(wr);
		
		var wb : FlxSprite = new FlxSprite(playbg.x + wallWidth, playbg.y + playbg.height - wallWidth);
		wb.makeGraphic(Std.int(playbg.width - 2 * wallWidth), wallWidth, wallColor);
		wb.scrollFactor.set();
		wb.cameras = [GP.CameraMain];
		_walls.add(wb);
		
		
		///////////////////////////////////////
		///// Create Targets //////////////////
		///////////////////////////////////////
		_targets = new FlxTypedGroup<FishTarget>();
		//_targets.scrollFactor.set();
		_targets._cameras = [GP.CameraMain];
		
		_targets.add(new FishTarget(playbg, wallWidth));
		_targets.add(new FishTarget(playbg, wallWidth));
		
		
		///////////////////////////////////////
		///// Create Player  //////////////////
		///////////////////////////////////////
		_player = new FishPlayer(this);
		_player.setPosition(300, 300);
	}
	
	override public function internalUpdate(elapsed:Float):Void
	{	
		_walls.update(elapsed);
		_targets.update(elapsed);
		_player.update(elapsed);
		
		for (t in _targets)
		{
			if (FlxG.overlap(t, _player))
			{
				t.overlap = true;
			}
			else 
			{
				t.overlap = false;
			}
			
			if (t.timer >= t.maxTimer)
			{
				t.resetToNewPosition();
				Score += 1;
			}
		}
	}
	
	public override function internalDrawTop() : Void
	{
		playbg.draw();
		_walls.draw();
		_targets.draw();
		_player.draw();
	}
	
	override public function internalDraw ()
	{
		
	}
	
}