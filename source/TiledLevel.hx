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
	
	// background image that will stay where it is (aka skybox). 
	public var bg : FlxSprite;
	
	// All Tiles that should be drawn in the same layer as the player
	public var foregroundTiles:FlxGroup;
	public var foregroundTiles2:FlxGroup;
	
	// All Tiles that can be drawn on top of the foreground tiles
	public var topTiles:FlxGroup;
	
	public var overlayObjects : FlxGroup;
	
	// the actual collision map. 
	// Since some tiles need a special collision box, 
	// the images are not used but a separate collider.
	// Those colloders will be stored in this collisionMap
	public var collisionMap : FlxSpriteGroup;
	
	
	public var exits : Array<LevelLeaver>;
	public var entries : Array<Entry>;
	public var collectibles : Array<Collectible>;
	
	public var drawStars : Bool = false;
	public var drawMoon : Bool = false;
	
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		levelPath = tiledLevel;
		
		foregroundTiles = new FlxGroup();
		foregroundTiles2 = new FlxGroup();
		topTiles = new FlxGroup();
		overlayObjects = new FlxGroup();
		foregroundTiles.cameras = [GP.CameraMain];
		foregroundTiles2.cameras = [GP.CameraMain];
		topTiles.cameras = [GP.CameraMain];
		overlayObjects.cameras = [GP.CameraOverlay];
		
		collisionMap = new FlxSpriteGroup();
		exits = new Array<LevelLeaver>();
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
						CreateCollisionTile(i, j, tileType);
					}
					else if (tileLayer.name == "tiles2")
					{
						foregroundTiles2.add(s);
						CreateCollisionTile(i, j, tileType);
					}
					else if (tileLayer.name == "top")
					{
						topTiles.add(s);
						//foregroundTiles.add(s);
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
		
			
			
			
			var bgscale : Float = 1;
			var bgOffsetX : Float = 0;
			var bgOffsetY : Float = 0;
						
			var s : String = layer.properties.get("backgroundScale");
			if (s != null)
			{
				bgscale = Std.parseFloat(s);
			}

			s = layer.properties.get("backgroundOffsetX");
			if (s != null)
			{
				bgOffsetX= Std.parseFloat(s);
			}
			s = layer.properties.get("backgroundOffsetY");
			if (s != null)
			{
				bgOffsetY = Std.parseFloat(s);
				//trace(bgOffsetY);
			}
			
			bg = new FlxSprite();
			bg.loadGraphic("assets/images/" + bgName, false, bgsx, bgsy);
			bg.offset.set(bgOffsetX, bgOffsetY);
			bg.origin.set();
			bg.scale.set(bgscale, bgscale);
			bg.cameras = [GP.CameraUnderlay];
			bg.scrollFactor.set(0, 0);
			
			if (layer.properties.get("stars") == "true")
			{
				drawStars = true;
			}
			if (layer.properties.get("moon") == "true")
			{
				drawMoon = true;
			}
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
			c.makeGraphic(16, 16, FlxColor.RED);
			c.alpha = 0.35;
			c.immovable = true;
		c.cameras = [GP.CameraMain];
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
			else if (objectLayer.name == "objects")
			{
				LoadOther(objectLayer);
			}
		}
	}
	
	function LoadOther(objectLayer:TiledObjectLayer) 
	{
		trace("load others");
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			//// objects in tiled are aligned bottom-left (top-left in flixel)
			if (o.gid != -1)
				y -= objectLayer.map.getGidOwner(o.gid).tileHeight;
			switch (o.type.toLowerCase())
			{
			case "campfire":
				trace("campfire");
				var c : CampFire = new CampFire(x, y);
				topTiles.add(c);
				
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
			case "teleport":
				//trace("exit");
				var t : Teleport = new Teleport();
				t.setPosition(x, y);
				t.makeGraphic(o.width, o.height, FlxColor.YELLOW);
				t.alpha = 0.2;
				t.targetLevel= o.properties.get("level");
				
				t.type = o.properties.get("type");
				t.entryID= Std.parseInt(o.properties.get("entryID"));
				t.createConditions(o.properties.get("conditions"));
				exits.push(t);
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
				trace("collectible");
				var n : String = o.name;
				var c : Collectible = new Collectible(n);
				
				c.setPosition(x, y);
				c.createConditions(o.properties.get("conditions"));
				collectibles.push(c);
			}
		}
	}

	public function getCollectibleByName (name : String) : Collectible
	{
		for (i in 0 ... this.collectibles.length)
		{
			var c : Collectible = this.collectibles[i];
			//if (!c.alive) continue;
			if ( c.name == name)
			{
				return c;
			}
		}
		return null;
	}
	
	public function getConditionalObjectByName(name : String) : ConditionalObject
	{
		for (i in 0 ... this.collectibles.length)
		{
			var c : ConditionalObject = this.collectibles[i];
			//if (!c.alive) continue;
			if ( c.name == name)
			{
				return c;
			}
		}
	
		for (i in 0 ... exits.length)
		{
			var e : LevelLeaver = exits[i];
			if (!e.alive) continue;
			if (e.name == name)
			{
				return e;
			}
		}
		return null;
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