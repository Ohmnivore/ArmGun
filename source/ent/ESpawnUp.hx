package ent;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class ESpawnUp extends ESpawn {
	
	public function new(X:Float, Y:Float) {
		super(X, Y);
		
		dir.set(0.0, -1.0);
	}
}