package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class SpriteFunctions
{
	static public function shadeSpriteWithBorder (s:FlxSprite, centerColor:FlxColor = FlxColor.WHITE, borderColor : FlxColor = FlxColor.GRAY)
	{
		//trace("shadesprite");
		s.pixels.lock();
		for (i in 0... Std.int(s.pixels.width))
		{
			for (j in 0... Std.int(s.pixels.height))
			{
				var ci : Int = s.pixels.getPixel32(i, j);
				var c : FlxColor = FlxColor.fromInt(ci);
				
				if (c.alpha == 0)
				{
					s.pixels.setPixel32(i, j, FlxColor.fromRGBFloat(0,0,0, 0));
				}
				else 
				{
					var border : Bool = false;
					if (i != 0)
					{
						var cil : Int = s.pixels.getPixel32(i - 1, j);
						var cl : FlxColor = FlxColor.fromInt(cil);
						if (cl.alpha == 0) 
							border = true;
					}
					if(i != Std.int(s.width))
					{
						var cir : Int = s.pixels.getPixel32(i + 1, j);
						var cr : FlxColor = FlxColor.fromInt(cir);
						if (cr.alpha == 0) 
							border = true;
					}
				
					if (j != 0)
					{
						var ciu : Int = s.pixels.getPixel32(i, j-1);
						var cu : FlxColor = FlxColor.fromInt(ciu);
						if (cu.alpha == 0) 
							border = true;
					}
					if(i != Std.int(s.width))
					{
						var cid : Int = s.pixels.getPixel32(i , j + 1);
						var cd : FlxColor = FlxColor.fromInt(cid);
						if (cd.alpha == 0) 
							border = true;
					}
				
					
					if (border)
					{
						s.pixels.setPixel32(i, j, borderColor);
					}
					else
					{
						s.pixels.setPixel32(i, j, centerColor);
					}
				}
			}
		}
		s.pixels.unlock();
	}
	
	public static function createHorizontalBar(spr:FlxSprite, w:Int, h: Int, pad:Int, col : FlxColor, shading : Float = 0.2)
	{
		var darkerColor : FlxColor = col.getDarkened(shading);
		var brighterColor : FlxColor = col.getLightened(shading);
		spr.makeGraphic(w, h, col, true);
		spr.pixels.lock();
		for (i  in 0 ... w)
		{
			for (jp in 0 ... pad)
			{
				var j = jp;
 				if (j > h) j = h;
				
				spr.pixels.setPixel32(i, j, brighterColor);
				spr.pixels.setPixel32(i, h - j, darkerColor);
				spr.pixels.setPixel32(i, h - j - 1, darkerColor);
			}
		}
		spr.pixels.unlock();
	}
	
	
	public static function createVerticalBar(spr:FlxSprite, w:Int, h: Int, pad:Int, col : FlxColor, shading : Float = 0.2)
	{
		var darkerColor : FlxColor = col.getDarkened(shading);
		var brighterColor : FlxColor = col.getLightened(shading);
		spr.makeGraphic(w, h, col, true);
		spr.pixels.lock();
		for (i  in 0 ... h)
		{
			for (jp in 0 ... pad)
			{
				var j = jp;
 				if (j > w) j = h;
				
				spr.pixels.setPixel32(j, i, brighterColor);
				spr.pixels.setPixel32(j, h - i, darkerColor);
				spr.pixels.setPixel32(j, h - i - 1, darkerColor);
			}
		}
		spr.pixels.unlock();
	}
}