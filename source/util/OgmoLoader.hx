package util;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import haxe.xml.Fast;

/**
 * ...
 * @author Ohmnivore
 */
class OgmoLoader {
	
	public var floor:FlxTilemap;
	public var ents:Array<FlxBasic> = [];
	
	public function new(MapString:String) {
		var doc:Fast = new Fast(Xml.parse(MapString));
		var lvl = doc.node.level;
		
		var floor = lvl.node.Floor;
		loadFloor(floor);
		
		var ents = lvl.node.Ents;
		for (ent in ents.elements)
			loadEnt(ent);
	}
	
	private function loadFloor(Floor:Fast):Void {
		var ts:String = "assets/images/" + Floor.att.tileset + ".png";
		floor = new FlxTilemap();
		#if cpp
		floor.loadMap(fixNegativeOne(Floor.innerData), ArtifactFix.artifactFix(ts, 16, 16), 16, 16, 0, 0, 2, 1);
		#else
		floor.loadMap(fixNegativeOne(Floor.innerData), ts, 16, 16, 0, 0, 2, 1);
		#end
		setCollision();
	}
	private function fixNegativeOne(Src:String):String {
		return StringTools.replace(Src, "-1", "0");
	}
	private function setCollision():Void {
		for (t in 0...16)
			floor.setTileProperties(t, FlxObject.NONE);
		var collidable:Array<Int> = [1, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15];
		for (c in collidable)
			floor.setTileProperties(c, FlxObject.ANY);
	}
	
	private function loadEnt(Ent:Fast):Void {
		var className:String = "ent." + Ent.name;
		var x:Int = Std.parseInt(Ent.att.x);
		var y:Int = Std.parseInt(Ent.att.y);
		var e:FlxObject = cast Type.createInstance(Type.resolveClass(className), [x, y]);
		ents.push(e);
	}
}