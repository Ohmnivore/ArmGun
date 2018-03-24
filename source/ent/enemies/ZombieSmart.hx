package ent.enemies;
import flixel.FlxObject;
import flixel.util.FlxVector;
/**
 * ...
 * @author Ohmnivore
 */
class ZombieSmart extends Zombie {

	public function new(X:Float, Y:Float) {
		super(X, Y);
		
		points = 20;
		health = 4;
		
		RUNDRAG = 1024;
		RUNMAX = 32;
		ALERT_RANGE = 32;
		
		init("assets/images/zombie_smart");
		
		animation.get("attack").frameRate = 24;
	}
	
	override public function createRunState(Z:Zombie):FSMState {
		return new SmartRunState(Z);
	}
}

class SmartRunState extends FSMState {
	
	public var ATTACK_TRIGGER:Int = 16;
	public var RUNSPEED:Int = 256;
	
	public var z:Zombie;
	
	public function new(Z:Zombie) {
		super();
		z = Z;
	}
	
	override public function update():Void {
		super.update();
		
		var p:Player = Reg.s.p;
		var pPos = p.getMidpoint();
		var zPos = z.getMidpoint();
		
		var vx = new FlxVector(pPos.x - zPos.x, pPos.y - zPos.y);
		vx = vx.normalize();
		vx = vx.scale(RUNSPEED);
		z.velocity.copyFrom(vx);
		
		if (z.animation.name == "run") {
			if (z.velocity.x < 0)
				z.facing = FlxObject.LEFT;
			if (z.velocity.x > 0)
				z.facing = FlxObject.RIGHT;
		}
		
		if (z.animation.name == "run" || z.animation.name == "idle" || z.animation.finished) {
			if (Math.abs(z.velocity.x) < 6 && Math.abs(z.velocity.y) < 6)
				z.animation.play("idle");
			else
				z.animation.play("run");
		}
		
		if (zPos.distanceTo(pPos) <= ATTACK_TRIGGER)
			fsm.pushState(z.createAttackState(z));
	}
}