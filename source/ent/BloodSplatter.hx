package ent;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class BloodSplatter extends FlxEmitter {

	public function new(X:Float, Y:Float) {
		super(X, Y, 16);
		for (i in 0...maxSize) {
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(2, 2, 0xffff0000);
			add(p);
		}
		setRotation();
		setXSpeed(-128, 128);
		setYSpeed(-96, 96);
		particleDrag.set(200, 200);
		setAlpha(1, 1, 0, 0);
		start(true, 3.0, 0, 0, 0.5);
		Reg.s.ents.add(this);
		Reg.s.emitters.add(this);
		
		new FlxTimer(4.0, function(T:FlxTimer):Void {
			Reg.s.ents.remove(this, true);
			Reg.s.emitters.remove(this, true);
			kill();
			destroy();
		});
	}
}