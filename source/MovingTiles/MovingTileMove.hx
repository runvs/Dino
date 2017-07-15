package;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class MovingTileMove extends MovingTile
{
	public var moveSpeed : Float = 15;
	private var _currendIdx : Int = 0;
	private var _currentDir : FlxVector;
	private var _currentTimeRemaining : Float = 0;
	
	private var _positions : Array<MovingTilePlatformPosition>;
	
	
	public function new(?X:Float=0, ?Y:Float=0, ?W : Int = 16) 
	{
		super(X, Y);
		this.makeGraphic(W, Std.int(GP.WorldTileSizeInPixel), FlxColor.fromRGB(255, 0, 0));
		_sprite.makeGraphic(W, Std.int(GP.WorldTileSizeInPixel), FlxColor.PINK);
		_positions = new Array<MovingTilePlatformPosition>();
		resetCamera();
		_currentDir = new FlxVector();
		_following = true;
		//changeDirection();
		
	}

	override public function update(elapsed:Float):Void 
	{
		//trace(this.x + " " + this.y);
		super.update(elapsed);
		_sprite.update(elapsed);
		if (_positions.length >= 1)
		{			
			var dx : Float = x - _positions[_currendIdx].x;
			var dy : Float = y - _positions[_currendIdx].y;
			var dist : Float = dx * dx + dy * dy;
			if (_currentTimeRemaining <= 0  || dist < 0.5)	// TODO check dist condition
			{
				_currendIdx++;
				if (_currendIdx >= _positions.length)
				{
					_currendIdx = 0;
				}
				changeDirection();
			}
		}
		else
		{
			this.velocity.set();
		}
	}
	
	override public function draw():Void 
	{
		_sprite.draw();
		//super.draw();
	}
	
	private function changeDirection()
	{	
		this.velocity.set();
		
		_currentDir.set(x - _positions[_currendIdx].x, y - _positions[_currendIdx].y);
		var l : Float = _currentDir.length;
		_currentDir = _currentDir.normalize();
		
		_currentTimeRemaining = l / moveSpeed + _positions[_currendIdx].wait;
		
		FlxTween.tween(this, { alpha : 1 }, _positions[_currendIdx].wait, { 
			onComplete:function(t) 
			{ 
				this.velocity.set(-_currentDir.x * moveSpeed, -_currentDir.y * moveSpeed);
			}
		} );
	}
	
	override public function resetMe() 
	{
		super.resetMe();
		_following = true;
		_touched = false;
		_sprite.velocity.set(0, 0);
		_sprite.acceleration.set(0, 0);
		
		_sprite.offset.set();
		_sprite.color = FlxColor.WHITE;
	}
	
	override public function resetCamera() 
	{
		//super.resetCamera();
		_sprite.cameras = [GP.CameraMain];
	}
	
	//override function SpriteFollows():Void 
	//{
		//_sprite.setPosition((x + GP.WorldTileSizeInPixel/2) * GP.CameraMain.zoom + 8  , (y+ GP.WorldTileSizeInPixel/2) * GP.CameraMain.zoom - 4);
	//}
	
	public function AddPlatformPositions(idstring : String ,positions : Array < MovingTilePlatformPosition>)
	{
		
		var ids : Array<String> = idstring.split(",");
		for (i in 0...ids.length)
		{
			var s :String = ids[i];
			for (j in 0...positions.length)
			{
				var ppos : MovingTilePlatformPosition = positions[j];
				if (ppos.name == s)
				{
					this.AddOnePlatformPosition(ppos);
					break;
				}
			}
		}	
	}
	
	private function AddOnePlatformPosition(ppos : MovingTilePlatformPosition)
	{
		if (ppos != null)
			_positions.push(ppos);
	}
}