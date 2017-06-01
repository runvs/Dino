package;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class WindSystem
{

	private var blows : Array<Blowable>;
	private var timer : Float = GP.WorldWindUpdateTime;
	
	private var left : Float = 0;
	private var right : Float = 0;
	
	
	private var currents : Array<Float>;
	
	
	private var d : PlayableCharacter = null;
	private var dinoOldX : Float = 0;
	private var dinoOldY : Float = 0;
	
	public function new() 
	{
		blows = new Array<Blowable>();
		currents = new Array<Float>();
		
	}

	public function addGrassArea(ga:GrassArea)
	{
		for (g in ga)
		{
			add(g, false);
		}
		Recalculate();
	}
	
	
	
	public function add (b : Blowable, recalc : Bool = true)
	{
		blows.push(b);
		if (recalc)
		{
			Recalculate();
		}
	}
	
	function Recalculate() 
	{
		left = 50000;
		right = -50000;
		for (b in blows)
		{
			if (b.x < left) left = b.x;
			if (b.x > right) right = b.x;
		}
		var N : Int = 2;
		for (i in 0...N-1)
		{
			var c : Float = left + (right - left) * i / (N-1);
			currents.push(c);
		}
		
	}
	
	public function update ( elapsed : Float)
	{
		timer -= elapsed;
		
		if (timer <= 0)
		{
			timer += GP.WorldWindUpdateTime;
			BlowUpdate();
		}	
		
		
	}
	
	function BlowUpdate() 
	{
		var dinoHasMoved : Bool = false;
		if (d != null)
		{
			var dx : Float = dinoOldX - d.x;
			var dy : Float = dinoOldY - d.y;
			if (Math.abs(dx) > 3 || Math.abs(dy) > 3)
			{
				dinoOldX = d.x;
				dinoOldY = d.y;
				dinoHasMoved = true;
			}
		}
		for (b in blows)
		{
			for (currentX in currents)
			{
				if (b.x < currentX && b.x > currentX - GP.WorldWindUpdateTime * GP.WorldWindSpeedInPixelsPerSecond)
				{
					b.blow();
				}	
			}
			if (dinoHasMoved)
			{
				if(FlxG.overlap(d, b))
				{
					//trace("wind overlap");
					b.blow();
				}
			}
		}
		for (i in 0...currents.length)
		{
			currents[i] -= GP.WorldWindUpdateTime * GP.WorldWindSpeedInPixelsPerSecond;
			
			if (currents[i] < left) currents[i] = right;
		}
		
		
	}
	
	public function setDinoPosition(p : PlayableCharacter)
	{
		d = p;
	}
}