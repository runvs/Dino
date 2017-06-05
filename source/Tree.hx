package;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class Tree extends Blowable
{
	
	private var dropParticles : Bool = false;
	public var front : Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, W : Int, H:Int) 
	{
		super(X, Y);
		
	
		//loadGraphic(AssetPaths.grass__png, true, 8, 8, false);
		loadTreeGraphic(x, y, W, H);
		this.cameras = [GP.CameraMain];
	}
	
	function loadTreeGraphic(x:Float, y:Float, w:Int, h:Int) 
	{
		
		if (h == 32)
		{
			var r : Int = DeterministicRandom.int(0, 2);
			if (r == 0)
			{
				loadGraphic(AssetPaths.tree_large_0__png, false, 32, 32);
				dropParticles = true;
			}
			else if (r == 1)
			{
				loadGraphic(AssetPaths.tree_large_1__png, false, 32, 32);
				dropParticles = true;
			}
			else if (r == 2)
			{
				loadGraphic(AssetPaths.tree_large_2__png, false, 16, 32);
			}
		}
		else if (h == 24)
		{
			var r : Int = DeterministicRandom.int(0, 1);
			var fn : String = "assets/images/trees/tree_med_" + Std.string(r) + ".png";
			y += 6;
			loadGraphic(fn, false, 16, 24);
			
		}
		else if (h == 16)
		{
			var r : Int = DeterministicRandom.int(0, 9);
			var fn : String = "assets/images/trees/tree_small_" + Std.string(r) + ".png";
			loadGraphic(fn, false, 16,16);
			
		}
		
	}
	
	public function resetCamera()
	{
		this.cameras =  [GP.CameraMain];
		
	}
	
}