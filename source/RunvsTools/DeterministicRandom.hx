package;

/**
 * ...
 * @author  Simon Weis
 * This is a simple random class that uses IBM's RANDU implementation (because it is simple).
 * Note that this random number generator fails the spectral test for d > 2, so you should only use it for
 * random numbers in dimension 1 or 2. 
 */
class DeterministicRandom
{
	public static var v (default, null) : Int = 1;
	private static var mod : Int = 1;
	private static var mul : Int = 1;
	private static var initialized : Bool = false;
	public static function getNext() : Int 
	{
		if (!initialized) reset();
		
		var vnext : Int = mul * (v % mod);
		v = vnext;
		return v;
	}
	
	public static function int(min:Int, max : Int) : Int 
	{
		var i : Int = Std.int(Math.abs(getNext()));
		var range : Int = max - min +1 ;
		
		var res :Int = (i % range) + min;
		return res;
	}
	
	
	public static function reset (vdef:Int = 1) 
	{
		v = vdef;
		if (!initialized)
		{
			mul = Std.int(Math.pow(2, 16)) + 3;
			mod = Std.int(Math.pow(2, 31));
			initialized = true;
		}
	}
}