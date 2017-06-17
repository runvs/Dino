package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class FishState extends BasicState
{
	
	public var playbg : FlxSprite;
	public var wallWidth : Int = 2;
	private var _walls : FlxSpriteGroup;
	private var _targets : FlxTypedGroup<FishTarget>;
	private var _player : FishPlayer;
	
	private var _dino : FlxSprite;
	private var _dinoAnimTimer : Float = 10;
	private var _speech : SpeechBubble;
	
	private var _caughtFishList : FlxSpriteGroup;
	
	private var _caughtFishNumber : Int = 0;
	
	private var _nextStageName : String = "s3_e0_end";
	
	public function new() 
	{
		super();
		_levelName = "assets/data/fishing.tmx";
		_caughtFishNumber = 0;
	}
	
	public function getScore()
	{
		return _caughtFishList.length;
	}
	
	override public function create():Void
	{
		super.create();
		LoadLevel(_levelName);
		
		_caughtFishList = new FlxSpriteGroup();
		_caughtFishList.scrollFactor.set();
		_caughtFishList.cameras = [GP.CameraMain];
		
		///////////////////////////////////////
		//// Creating Playing Background //////
		///////////////////////////////////////
		
		playbg = new FlxSprite(45, 45);
		playbg.makeGraphic(160, 80, FlxColor.fromRGB(47,55,64));
		playbg.scrollFactor.set();
		playbg.cameras = [GP.CameraMain];
		
		///////////////////////////////////////
		//// Creating Walls ///////////////////
		///////////////////////////////////////
		_walls = new FlxSpriteGroup();
		_walls.scrollFactor.set();
		_walls._cameras = [GP.CameraMain];
		
		var wallColor : FlxColor = FlxColor.fromRGB(47,55,64);
		//var wallColor : FlxColor = FlxColor.WHITE;
		
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
		//_targets.add(new FishTarget(playbg, wallWidth));
		
		
		///////////////////////////////////////
		///// Create Player  //////////////////
		///////////////////////////////////////
		_player = new FishPlayer(this);
		_player.setPosition(300, 300);
		
		///////////////////////////////////////
		///// Create Dino anim ////////////////
		///////////////////////////////////////
		
		_dino = new FlxSprite(18, 14);
		_dino.loadGraphic(AssetPaths.dino_angeln__png, true, 24, 18);
		_dino.animation.add("pick", [for (v in 0...5) v], 5, false);
		_dino.animation.add("throw", [for (v in 6...15) v], 5, false);
		_dino.animation.add("fish1", [for (v in 15...18) v], 3, true);
		_dino.animation.add("fish2", [for (v in 19...26) v], 4, true);
		_dino.animation.play("throw");
		
		var ti : FlxTimer = new FlxTimer();
		ti.start(2, function (t) { _dino.animation.play("fish1", true); } );
		
		_dino.cameras = [GP.CameraMain];
		
		_speech = new SpeechBubble(_dino, "heart", 0.5);
		_speech.alpha = 0;
		_speech.setIconAlpha(0);
	}
	
	override public function internalUpdate(elapsed:Float):Void
	{	
		_walls.update(elapsed);
		_targets.update(elapsed);
		_player.update(elapsed);
		_dino.update(elapsed);
		_speech.update(elapsed);
		
		_dinoAnimTimer -= elapsed;
		
		if (_dinoAnimTimer <= 0)
		{
			_dino.animation.play("fish2", true);
			var ti2 : FlxTimer = new FlxTimer();
			while(_dinoAnimTimer <= 0)_dinoAnimTimer = FlxG.random.floatNormal(10, 2);
			
			ti2.start(2, function(t) { _dino.animation.play("fish1", true); } );
		}
		
		
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
				addFishToChaughtList(t);
				if (t._fishtype == 0)
				{
					_caughtFishNumber += 1;
					trace("correct fish caught");
				}
				else
				{
					trace("wrong fish!");
				}
				t.resetToNewPosition();
				_speech = new SpeechBubble(_dino, "heart", 1.25);
			}
		}
	
		if (_caughtFishNumber >= 4)
		{
			StageInfo.getStage(_nextStageName).startStage();
		}
	}
	
	public override function internalDrawTop() : Void
	{
		playbg.draw();
		_walls.draw();
		_targets.draw();
		_player.draw();
		_caughtFishList.draw();
	}
	
	override public function internalDraw ()
	{
		_dino.draw();
		_speech.draw();
	}
	
	function addFishToChaughtList(t: FishTarget):Void 
	{
		var s : FlxSprite = new FlxSprite(4 + _caughtFishList.length * 18, FlxG.height/GP.CameraMain.zoom-24);
		s.scrollFactor.set();
		s.cameras = [GP.CameraMain];
		s.loadGraphic(AssetPaths.item_fish__png, true, 16, 16);
		s.animation.add("idle", [t._fishtype]);
		s.animation.play("idle");
		_caughtFishList.add(s);
	}
	
}