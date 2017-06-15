package;

/**
 * ...
 * @author 
 */
class HurtingSpriteRight extends HurtingSprite
{

	public function new(?X:Float=0, ?Y:Float=0, alt: Bool = false) 
	{
		super(X, Y);
		if (!alt)
		{
			LoadHurtingGraphic(TiledLevel.TileIDHurtingRight1);
		}
		else
		{
			LoadHurtingGraphic(TiledLevel.TileIDHurtingRight2);
		}
	}
	
}