package;

/**
 * ...
 * @author 
 */
class HurtingSpriteBot extends HurtingSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		LoadHurtingGraphic(TiledLevel.TileIDHurtingBottom);
	}
	
}