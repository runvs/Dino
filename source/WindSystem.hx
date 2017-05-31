package;

/**
 * ...
 * @author 
 */
class WindSystem
{

	private var blows : Array<IBlowable>;
	private var timer : Float = GP.WorldWindUpdateTime;
	
	private var left : Float = 0;
	private var right : Float = 0;
	
	private var currentX : Float;
	
	public function new() 
	{
		blows = new Array<IBlowable>();
	}

	public function addGrassArea(ga:GrassArea)
	{
		for (g in ga)
		{
			add(g, false);
		}
		Recalculate();
	}
	
	
	
	public function add (b : IBlowable, recalc : Bool = true)
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
			if (b.getX() < left) left = b.getX();
			if (b.getX() > right) right = b.getX();
		}
		currentX = right;
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
		for (b in blows)
		{
			if (b.getX() < currentX && b.getX() > currentX - GP.WorldWindUpdateTime * GP.WorldWindSpeedInPixelsPerSecond)
			{
				b.blow();
			}
		}
		currentX -= GP.WorldWindUpdateTime * GP.WorldWindSpeedInPixelsPerSecond;
		if (currentX < left) currentX = right;
	}
}