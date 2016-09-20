package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import haxe.io.Path;

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	
	private var _tileSet:TiledTileSet;
	
	public var levelPath : String = "";
	public var actor : String = "";
	
	// background image that will stay where it is (aka skybox). 
	public var bg : FlxSprite;
	
	// All Tiles that should be drawn in the same layer as the player
	public var foregroundTiles:FlxGroup;
	public var foregroundTiles2:FlxGroup;
	
	// All Tiles that can be drawn on top of the foreground tiles
	public var topTiles:FlxGroup;
	
	// the actual collision map. 
	// Since some tiles need a special collision box, 
	// the images are not used but a separate collider.
	// Those colloders will be stored in this collisionMap
	public var collisionMap : FlxSpriteGroup;
	
	
	public var exits : Array<Exit>;
	public var entries : Array<Entry>;
	public var collectibles : Array<Collectible>;
	
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		levelPath = tiledLevel;
		
		foregroundTiles = new FlxGroup();
		foregroundTiles2 = new FlxGroup();
		topTiles = new FlxGroup();
		collisionMap = new FlxSpriteGroup();
		
		exits = new Array<Exit>();
		entries = new Array<Entry>();
		collectibles = new Array<Collectible>();
		
		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;
		
			
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
			_tileSet = null;
			
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					_tileSet = ts;
					break;
				}
			}
			
			if (_tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
			var imagePath 		= new Path(_tileSet.imageSource);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
				_tileSet.tileWidth, _tileSet.tileHeight, OFF, _tileSet.firstGID, 1, 1);
				
			for (i in 0...tilemap.widthInTiles)
			{
				for (j in 0...tilemap.heightInTiles)
				{			
					if (tileLayer.name == "top")
					{
						var tileType : Int = tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						topTiles.add(s);
					}
					else
					{
						var tileType : Int = tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						s.cameras = [GP.CameraMain];
						if (tileLayer.name == "tiles")
						{
							foregroundTiles.add(s);
						}
						else if (tileLayer.name == "tiles2")
						{
							foregroundTiles2.add(s);
						}
						CreateCollisionTile(i, j, tileType);
					}
				}
			}
		}
		loadObjects();
		loadBackground();		
	}
	
	function loadBackground() 
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT) continue;
			if (layer.name != "global") continue;
			//trace("global layer found");
			
			var actorname : String = layer.properties.get("actor");
			if (actorname == null || actorname == "")
			{
				trace("No Actor set in level. using default dino guy");
				actor = "dino";
			}
			else
			{
				actor = actorname;
			}
			
			var bgName : String = layer.properties.get("background");
			if (bgName == null)
			{
				trace("Background not set!");
				return;
			}
			//trace("parse xy");
			var bgsx : Int = Std.parseInt(layer.properties.get("backgroundSizeX"));
			var bgsy : Int = Std.parseInt(layer.properties.get("backgroundSizeY"));
			//trace("create sprite");
			bg = new FlxSprite();
			bg.loadGraphic("assets/images/"+bgName, false, bgsx, bgsy);
			bg.cameras = [GP.CameraUnderlay];
			bg.scrollFactor.set(0, 0);
		}
		
	}
	
	
	
	function CreateCollisionTile(x : Int, y : Int, type : Int) 
	{
		var cols : Int = _tileSet.numCols;
		var rows : Int = _tileSet.numRows;
		
		var rowIndex :Int = Std.int((type-1) / rows);
		//trace(Std.string(cols) + " " + Std.string(rows));
		
		if (rowIndex == 0)
		{	
			// no collision for tiles in row 0
			return;
		}
		else if (rowIndex == 1)
		{
			//trace("addinc collision sprite at " + Std.string(x) + " " + Std.string(y) );
			var c : FlxSprite = new FlxSprite(x * 16, y * 16);
			c.makeGraphic(16, 16);
			c.immovable = true;
			collisionMap.add(c);
		}
		
	}
	
	private function loadSpecialTile(x:Int, y:Int, type : Int)
	{
		if (type == 0) return;
	}
	
	
	public function loadObjects()
	{
		var layer:TiledObjectLayer;
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			//objects layer
			if (objectLayer.name == "exits")
			{	
				LoadExits(objectLayer);
			}
			else if (objectLayer.name == "collectibles")
			{
				LoadCollectibles(objectLayer);
			}
		}
	}
	
	
	function LoadExits(objectLayer:TiledObjectLayer):Void 
	{
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			//// objects in tiled are aligned bottom-left (top-left in flixel)
			if (o.gid != -1)
				y -= objectLayer.map.getGidOwner(o.gid).tileHeight;
			switch (o.type.toLowerCase())
			{
			case "exit":
				//trace("exit");
				var e : Exit = new Exit();
				e.setPosition(x, y);
				e.makeGraphic(o.width, o.height, FlxColor.YELLOW);
				e.alpha = 0.2;
				e.targetStage = o.properties.get("name");
				e.type = o.properties.get("type");
				e.createConditions(o.properties.get("conditions"));
				exits.push(e);
			case "entry":
				//trace("entry");
				var e : Entry = new Entry();
				e.setPosition(x, y);
				e.entryID = Std.parseInt(o.properties.get("ID"));
				e.makeGraphic(o.width, o.height, FlxColor.GREEN);
				e.alpha = 0.2;
				entries.push(e);
			}
		}
	}
	
	
	function LoadCollectibles(objectLayer:TiledObjectLayer) 
	{
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			//
			//// objects in tiled are aligned bottom-left (top-left in flixel)
			if (o.gid != -1)
				y -= objectLayer.map.getGidOwner(o.gid).tileHeight;
			if ( o.type.toLowerCase() == "collectible")
			{
				//trace("collectible");
				var n : String = o.name;
				var c : Collectible = new Collectible(n);
				
				c.setPosition(x, y);
				c.createConditions(o.properties.get("conditions"));
				collectibles.push(c);
			}
		}
	}
	
	public function getEntryPoint(tID: Int) : FlxPoint
	{
		var p : FlxPoint = new FlxPoint();
		
		for (e in entries)
		{
			if (e.entryID == tID)
			{
				p.x = e.x;
				p.y = e.y + 16;
				break;
			}
		}
		return p;
	}
}