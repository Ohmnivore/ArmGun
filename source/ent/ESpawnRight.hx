package ent;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class ESpawnRight extends ESpawn {
	
	public function new(X:Float, Y:Float) {
		super(X, Y);
		
		dir.set(1.0, 0.0);
	}
}