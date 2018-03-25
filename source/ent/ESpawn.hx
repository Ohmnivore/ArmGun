package ent;
import ent.enemies.*;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author ...
 */
class ESpawn extends FlxObject {
	
	public var dir:FlxVector = new FlxVector();
	public var randomDirAngle:Float = 45.0;
	public var minImpulse:Float = 1000.0;
	public var maxImpulse:Float = 2000.0;
	
	public var minSpawnDelay:Float = 3.0;
	public var maxSpawnDelay:Float = 10.0;
	
	public function new(X:Float, Y:Float) {
		super(X, Y, 11, 6);
		
		scheduleSpawnTimer();
	}
	
	override public function update():Void {
		super.update();
	}
	
	private function scheduleSpawnTimer():Void {
		var spawnDelay = FlxRandom.floatRanged(minSpawnDelay, maxSpawnDelay);
		
		new FlxTimer(spawnDelay, function(T:FlxTimer){
			spawn();
			scheduleSpawnTimer();
		});
	}
	
	private function spawn():Void {
		var enemies:Array<Class<Enemy>> = [ZombieSlow, ZombieFast, ZombieSmart];
		var c = FlxRandom.weightedGetObject(enemies, [4.0, 2.0, 0.5]);
		var ent:Enemy = cast Type.createInstance(c, [x, y]);
		
		Reg.s.ents.add(ent);
		
		var impulse = new FlxVector();
		impulse.copyFrom(dir);
		impulse.rotateByDegrees(FlxRandom.floatRanged(-randomDirAngle / 2.0, randomDirAngle / 2.0));
		impulse.scale(FlxRandom.floatRanged(minImpulse, maxImpulse));
		ent.velocity.copyFrom(impulse);
	}
}