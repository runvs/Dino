package;

/**
 * ...
 * @author 
 */
class HurtingSpriteLeft extends HurtingSprite
{

	public function new(?X:Float=0, ?Y:Float=0, alt: Bool = false) 
	{
		super(X, Y);
		if (!alt)
		{
			LoadHurtingGraphic(TiledLevel.TileIDHurtingLeft1);
		}
		else
		{
			LoadHurtingGraphic(TiledLevel.TileIDHurtingLeft2);
		}
	}
	
}