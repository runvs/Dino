package;


import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
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
	
	public var clouds : CloudLayer;
	public var cloudName : String = "none";
	
	public var parallaxName : String = "none";
	public var parallax : ParallaxLayer;
	
	
	// All Tiles that should be drawn in the same layer as the player
	public var foregroundTiles:FlxGroup;
	public var foregroundTiles2:FlxGroup;
	
	// All Tiles that can be drawn on top of the foreground tiles
	public var topTiles:FlxGroup;
	
	//public var overlayObjects : FlxGroup;
	
	// the actual collision map. 
	// Since some tiles need a special collision box, 
	// the images are not used but a separate collider.
	// Those colloders will be stored in this collisionMap
	public var collisionMap : FlxSpriteGroup;
	
	
	
	public var hurtingTiles : Array<HurtingSprite>;
	public var movingTiles : Array<MovingTile>;
	
	public var exits : Array<LevelLeaver>;
	public var entries : Array<Entry>;
	public var collectibles : Array<Collectible>;
	public var enemies: Array<BasicEnemy>;
	public var grass : Array<GrassArea>;
	public var trees : Array<Tree>;
	public var treesTop : Array<Tree>;
	public var doors : Array<Door>;
	public var speechBubbleAreas : Array<SpeechBubbleArea>;
	
	public var drawStars : Bool = false;
	public var drawMoon : Bool = false;
	public var drawFlocks : Bool = false;
	public var drawDroplets : Bool = false;
	
	public var wind : WindSystem;
	
	public static var TileIDHurtingBottom 		(default, null) 	: Int = 144;
	public static var TileIDHurtingTop    		(default, null)		: Int = 145;
	public static var TileIDHurtingRight1   	(default, null)		: Int = 146;
	public static var TileIDHurtingLeft1   		(default, null)		: Int = 147;
	public static var TileIDHurtingTopFalling 	(default, null)		: Int = 149;
	// bottom falling is not available
	public static var TileIDHurtingRight2   	(default, null)		: Int = 150;
	public static var TileIDHurtingLeft2   		(default, null)		: Int = 151;
	
	
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		levelPath = tiledLevel;
		
		foregroundTiles = new FlxGroup();
		foregroundTiles2 = new FlxGroup();
		topTiles = new FlxGroup();
		foregroundTiles.cameras = [GP.CameraMain];
		foregroundTiles2.cameras = [GP.CameraMain];
		topTiles.cameras = [GP.CameraMain];
		
		collisionMap = new FlxSpriteGroup();
		exits = new Array<LevelLeaver>();
		entries = new Array<Entry>();
		collectibles = new Array<Collectible>();
		hurtingTiles = new Array<HurtingSprite>();
		movingTiles = new Array<MovingTile>();
		enemies = new Array<BasicEnemy>();
		
		grass = new Array<GrassArea>();
		trees = new Array<Tree>();
		treesTop = new Array<Tree>();
		wind = new WindSystem();
		
		doors = new Array<Door>();
		var collisionArray : Array<Int> = new Array<Int>();
		
		speechBubbleAreas = new Array<SpeechBubbleArea>();
		
		var tilemap:FlxTilemap = new FlxTilemap();
		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;
		
			
			var tileSheetName:String = tileLayer.properties.get("tileset");
			trace("tileSheetName: " + tileSheetName);
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
			
			
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
				_tileSet.tileWidth, _tileSet.tileHeight, OFF, _tileSet.firstGID, 1, 1);
				
			for (i in 0... (tilemap.heightInTiles * tilemap.widthInTiles))
			{
				collisionArray.push(0);
			}

			
			
			var tileSheetPath : String = "assets/images/" + tileSheetName ;
			for (i in 0...tilemap.widthInTiles)
			{
				for (j in 0...tilemap.heightInTiles)
				{			
					var tileType : Int = tilemap.getTile(i, j);
					var s : FlxSprite = new FlxSprite(i * GP.WorldTileSizeInPixel, j * GP.WorldTileSizeInPixel);
					s.immovable = true;
					s.loadGraphic(tileSheetPath, true, GP.WorldTileSizeInPixel, GP.WorldTileSizeInPixel);
					s.animation.add("idle", [tileType-1]);
					s.animation.play("idle");
					s.cameras = [GP.CameraMain];
					if (tileLayer.name == "tiles")
					{
						if (CreateSpecialTile(i, j, tileType))
						{
							continue;
						}
						foregroundTiles.add(s);
						CreateCollisionTile(i, j, tileType, tilemap.widthInTiles, collisionArray);
						
					}
					else if (tileLayer.name == "tiles2")
					{
						foregroundTiles2.add(s);
						CreateCollisionTile(i, j, tileType, tilemap.widthInTiles, collisionArray);
					}
					else if (tileLayer.name == "top")
					{
						topTiles.add(s);
					}
				}
			}
		}
		
		MergeColliders(collisionArray, tilemap.widthInTiles, tilemap.heightInTiles);
		
		loadObjects();
		loadGlobalProperties();		
		
		clouds = new CloudLayer(cloudName);
		parallax = new ParallaxLayer(parallaxName);
	}
	
	function MergeColliders(collisionArray : Array<Int>, sx : Int, sy: Int) 
	{
		var refinedCollisions : Array<Array<Int> > = new Array<Array<Int> >();
		refinedCollisions = CollisionMerger.Merge(collisionArray, sx,sy);
		
		for (i in 0 ... collisionArray.length)
		{
			if (refinedCollisions[i][0] == 0)
			{
				continue;
			}
			else
			{
				var t : FlxSprite = new FlxSprite(0, 0);
				t.makeGraphic(Std.int(GP.WorldTileSizeInPixel* refinedCollisions[i][1]), Std.int(GP.WorldTileSizeInPixel * refinedCollisions[i][0]));
				SpriteFunctions.shadeSpriteWithBorder(t, FlxColor.fromRGB(255,0,0,100));
				t.setPosition(i % sx * GP.WorldTileSizeInPixel, Std.int(i / sx) * GP.WorldTileSizeInPixel);
				t.update(0.1);
				t.immovable = true;
				collisionMap.add(t);
			}

		}
		
	}
	
	function loadGlobalProperties() 
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
			}
			
			bg = new FlxSprite();
			bg.loadGraphic("assets/images/" + bgName, false, bgsx, bgsy);
			bg.offset.set(bgOffsetX, bgOffsetY);
			bg.origin.set();
			bg.scale.set(bgscale, bgscale);
			bg.cameras = [GP.CameraUnderlay];
			bg.scrollFactor.set(0, 0);
			
			if (layer.properties.get("stars") != null && layer.properties.get("stars") == "true")
			{
				drawStars = true;
			}
			if (layer.properties.get("moon") != null && layer.properties.get("moon") == "true")
			{
				drawMoon = true;
			}
			if (layer.properties.get("droplets") != null && layer.properties.get("droplets") == "true")
			{
				drawDroplets = true;
			}
			if (layer.properties.get("flocks") != null && layer.properties.get("flocks") == "true")
			{
				drawFlocks = true;
			}
			if (layer.properties.get("clouds") != null)
			{
				cloudName = layer.properties.get("clouds");
			}
			if (layer.properties.get("parallax") != null)
			{
				parallaxName = layer.properties.get("parallax");
			}
		}
		
	}
	
	
	function CreateSpecialTile(x: Int , y: Int, tileType:Int) : Bool
	{
		if (tileType == TileIDHurtingTop + 1)
		{
			var h : HurtingSprite = new HurtingSpriteTop(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel);
			hurtingTiles.push(h);
			
		}
		else if (tileType == TileIDHurtingRight1 + 1)
		{
			var h : HurtingSprite = new HurtingSpriteRight(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel, false);
			hurtingTiles.push(h);
		}
		else if (tileType == TileIDHurtingLeft1 + 1)
		{
			var h : HurtingSprite = new HurtingSpriteLeft(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel, false);
			hurtingTiles.push(h);
		}
		else if (tileType == TileIDHurtingBottom + 1)
		{
			var h : HurtingSprite = new HurtingSpriteBot(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel);
			hurtingTiles.push(h);
		}
		else if (tileType == TileIDHurtingTopFalling + 1)
		{
			var h : HurtingSprite = new HurtingSpriteTopFalling(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel);
			hurtingTiles.push(h);
		}
		else if (tileType == TileIDHurtingRight2 + 1)
		{
			var h : HurtingSprite = new HurtingSpriteRight(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel, true);
			hurtingTiles.push(h);
		}
		else if (tileType == TileIDHurtingLeft2 + 1)
		{
			var h : HurtingSprite = new HurtingSpriteLeft(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel, true);
			hurtingTiles.push(h);
		}
		else if (tileType == TileIDHurtingLeft2 + 2)
		{
			var s : MovingTileBreak = new MovingTileBreak(x * GP.WorldTileSizeInPixel, y * GP.WorldTileSizeInPixel);
			movingTiles.push(s);
		}
		else
		{
			// nothing to do here
			return false;
		}
		return true;
	}
	
	public function resetCameras()
	{
		for (c in collisionMap)
		{
			c.cameras = [GP.CameraMain];
		}
		bg.cameras = [GP.CameraUnderlay];
		clouds.resetCamera();
		parallax.resetCamera();
		for (g in grass)
		{
			g.resetCamera();
		}
		for (t in foregroundTiles) 
		{
			t.cameras = [GP.CameraMain];
		}
		for (t in foregroundTiles2)
		{
			t.cameras = [GP.CameraMain];
		}
		for (t in trees)
		{
			t.resetCamera();
		}
		for (t in treesTop)
		{
			t.resetCamera();
		}
		for (t in topTiles)
		{
			t.cameras = [GP.CameraMain];
			if (Std.is(t, CampFire))
			{
				var c : CampFire = cast t;
				c.resetCamera();
			}
		
		}
		for (h in hurtingTiles)
		{
			h.cameras = [GP.CameraMain];
		}
		for (s in movingTiles)
		{
			s.resetCamera();
		}
		for (e in exits)
		{
			e.resetCamera();
			//e.cameras = [GP.CameraMain];
		}
		for (e in entries)
		{
			e.cameras = [GP.CameraMain];
		}
		for (e in enemies)
		{
			e.resetCamera();
		}
		
		for (c in collectibles)
		{
			c.cameras = [GP.CameraMain];
			c.resetCamera();
		}
		for (e in enemies)
		{
			e.cameras = [GP.CameraMain];
		}
		for (d in doors)
		{
			d.resetCamera();
		}
		for (sba in speechBubbleAreas)
		{
			sba.resetCamera();
		}
	}
	
	
	function CreateCollisionTile(x : Int, y : Int, type : Int, tilemapWidthInTiles : Int, collisionArray : Array<Int>) 
	{
		var cols : Int = _tileSet.numCols;
		var rows : Int = _tileSet.numRows;
		
		var rowIndex : Int = Std.int((type-1) / rows);
		
		
		if (rowIndex >= 0 && rowIndex <= 6)
		{
			if (rowIndex == 0 && type == 0) return;
			var idx = x + y * tilemapWidthInTiles;
			collisionArray[idx] = 1;
		}
		else if (rowIndex == 0) // special collisions for row zero
		{	
			return;
		}
		
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
				LoadDoors(objectLayer);
			}
			else if (objectLayer.name == "collectibles")
			{
				LoadCollectibles(objectLayer);
			}
			else if (objectLayer.name == "objects")
			{
				LoadOther(objectLayer);
			}
			else if (objectLayer.name == "enemies")
			{
				LoadEnemies(objectLayer);
			}
			else if (objectLayer.name == "foliage")
			{
				LoadFoliage(objectLayer);
			}
			else if (objectLayer.name == "tutorial")
			{
				LoadTutorial(objectLayer);
			}
			else if (objectLayer.name == "platforms")
			{
				LoadPlatforms(objectLayer);
			}
			else if (objectLayer.name == "global") continue;
			else
			{
				trace ("WARNING: Unsupported object layer: " + objectLayer.name);
			}
		}
	}
	
	
	function LoadPlatforms(objectLayer:TiledObjectLayer) 
	{
		trace("load platform Positions");
		//DeterministicRandom.reset();
		var positions : Array<MovingTilePlatformPosition> = new Array<MovingTilePlatformPosition>();
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			var name :String = o.name;
			
			if(o.type.toLowerCase() == "ppos")
			{
				var ppos : MovingTilePlatformPosition = new MovingTilePlatformPosition(x, y);
				ppos.name = name;
				if (o.properties.get("wait") != null)
				{
					ppos.wait = Std.parseFloat(o.properties.get("wait"));
				}
				positions.push(ppos);
			}
		}
		trace(positions.length  + " platforms loaded");
		trace("load platforms");
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			var w:Int = o.width;
			var name :String = o.name;
			
			if(o.type.toLowerCase() == "moving")
			{
				trace("create Platform");
				var p : MovingTileMove = new MovingTileMove(x, y,w);
		
				var idstring : String = o.properties.get("ids");
				p.AddPlatformPositions(idstring, positions);
		
				movingTiles.push(p);
			}
		}
		
		
	}
	
	function LoadTutorial(objectLayer:TiledObjectLayer) 
	{
		trace("load tutorial");
		//DeterministicRandom.reset();
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			var w:Int = o.width;
			var h : Int = o.height;
			
			switch(o.type.toLowerCase())
			{
				case "sba":	// short for speechbubblearea
					var sba : SpeechBubbleArea = new SpeechBubbleArea(o.properties.get("icon"), x, y, w, h);
					sba.createConditions(o.properties.get("conditions"));
					speechBubbleAreas.push(sba);
			}
		}
	}
	
	function LoadDoors(objectLayer:TiledObjectLayer) 
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
			case "door":
				//trace("exit");
				var n : String = o.properties.get("name");
				var d : Door = new Door(x, y, n);
				
				var teleportName : String = o.properties.get("teleportName");
				
				d.leaver = getTeleport(teleportName);
				
				var open : String = o.properties.get("open");
				var close : String = o.properties.get("close");
				d.setKeyWords(open, close);
				
				doors.push(d);
			}
		}
	}
	
	private function getTeleport (n : String ) : LevelLeaver
	{
		for (e in exits)
		{
			if (e.LevelLeaverName == n)
			{
				return e;
			}
		}
		return null;
	}
	
	function LoadEnemies(objectLayer:TiledObjectLayer) 
	{
		trace("load enemies");
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			//// objects in tiled are aligned bottom-left (top-left in flixel)
			if (o.gid != -1)
				y -= objectLayer.map.getGidOwner(o.gid).tileHeight;
			switch (o.type.toLowerCase())
			{
			case "walkerlr":
				trace("walkerLR");
				var e : EnemyWalkLR = new EnemyWalkLR(x, y);
				var distance : Float = Std.parseFloat(o.properties.get("distance")) * GP.WorldTileSizeInPixel; 
				e.distance = distance;
				
				if (o.properties.get("start") != null) 
				e.setStart(Std.parseFloat(o.properties.get("start")));
				
				enemies.push(e);
			case "boar":
				trace("boar");
				var e : EnemyBoar = new EnemyBoar(x, y);
				var distance : Float = Std.parseFloat(o.properties.get("distance")) * GP.WorldTileSizeInPixel; 
				e.distance = distance;
				
				if (o.properties.get("start") != null) 
				e.setStart(Std.parseFloat(o.properties.get("start")));
				
				var px1 : FlxPoint = new FlxPoint ( e.x - GP.WorldTileSizeInPixel/2, e.y + 2);
				var px2 : FlxPoint = new FlxPoint ( e.x + e.width + distance + GP.WorldTileSizeInPixel / 2, e.y + 2);
				
				
				e.setLeftRightSpark(collisionMap.overlapsPoint(px1), collisionMap.overlapsPoint(px2));
				
				
				enemies.push(e);				
			default:
				trace ("unknown enemy type " + o.type.toLowerCase() );
			}
			
		}
		trace("load enemies finished. Loaded N=" + Std.string(enemies.length) + " enemies");
	}
	
	function LoadFoliage(objectLayer:TiledObjectLayer)
	{
		trace("load foliage");
		DeterministicRandom.reset();
		for (o in objectLayer.objects)
		{
			var x:Int = o.x;
			var y:Int = o.y;
			var w:Int = o.width;
			var h : Int = o.height;
			
			////// objects in tiled are aligned bottom-left (top-left in flixel)
			//if (o.gid != -1)
				//y -= objectLayer.map.getGidOwner(o.gid).tileHeight;
				//
			switch(o.type.toLowerCase())
			{
				case "grass":	// grass can only appear in grass areas
					//trace("grass");

					var ga : GrassArea = new GrassArea(x, y+h, w);
					grass.push(ga);
					wind.addGrassArea(ga);
				case "tree":
					//trace("tree");
					var t : Tree;
					if (o.properties.get("id") != null)
					{
						t = new Tree(x, y, w, h, Std.parseInt(o.properties.get("id")));
					}
					else
					{
						t = new Tree(x, y, w, h);
					}
					if (o.properties.get("front") != null)
					{
						t.front = (o.properties.get("front") == "true");
					}
					
					
					if (t.front)
					{
						treesTop.push(t);
					}
					else
					{
						trees.push(t);
					}
					wind.add(t, true);
				case  "treearea":
					trace("tree area not implemented yet");
				
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
				c.createConditions(o.properties.get("conditions"));
				topTiles.add(c);
				
			case "lightbeams":
				trace("lightbeams");
				var exitRight : Bool = o.properties.get("facing") == "right";
				
				var l : Lightbeams = new Lightbeams(x, y, exitRight);
				l.createConditions(o.properties.get("conditions"));
				topTiles.add(l);
				
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
				var l : Float = (o.properties.get("left")!= null ? Std.parseFloat(o.properties.get("left")) : 1.0 / 4.0 );
				var r : Float = (o.properties.get("right")!= null ?  Std.parseFloat(o.properties.get("right")) : 3.0 / 4.0);
				var e : Exit = new Exit(o.width, o.height, l, r);
				e.setPosition(x, y);
				e.targetStage = o.properties.get("name");
				e.type = o.properties.get("type");
				e.createConditions(o.properties.get("conditions"));
				exits.push(e);
			case "teleport":
				//trace("teleport");
				var l : Float = (o.properties.get("left")!= null ? Std.parseFloat(o.properties.get("left")) : 1.0 / 4.0 );
				var r : Float = (o.properties.get("right")!= null ?  Std.parseFloat(o.properties.get("right")) : 3.0 / 4.0);
				var t : Teleport = new Teleport(o.width, o.height, l, r, o.name);
				
				t.setPosition(x, y);
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
				
				c.setPosition(x, y );
				c.createConditions(o.properties.get("conditions"));
				
				
				if (o.properties.get("teleportToLevel") != null && o.properties.get("teleportToID") != null)
				{
					trace("collectible teleport: " + o.properties.get("teleportToLevel") + " " + o.properties.get("teleportToID") );
					c.setTeleport(o.properties.get("teleportToLevel"), Std.parseInt(o.properties.get("teleportToID")));
				}
				
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
		var found : Bool = false;
		for (e in entries)
		{
			if (e.entryID == tID)
			{
				p.x = e.x;
				p.y = e.y + 16;
				found = true;
				break;
			}
		}
		if (!found) throw "ERROR: No entry point with ID: " + tID;
		return p;
	}
}