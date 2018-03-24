package ent.enemies;
import ent.FSM;
import ent.FSMState;
import ent.Player;
import ent.enemies.Enemy;
import ent.wep.CDRom.CDRomBullet;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
/**
 * ...
 * @author Ohmnivore
 */
class ZombieSlow extends Enemy {

	public var RUNDRAG:Int = 1024;
	public var RUNMAX:Int = 144;
	public var ALERT_RANGE:Int = 32;
	
	private var fsm:FSM;
	
	public function new(X:Float, Y:Float) {
		super(X, Y);
		setAnim();
		setPhys();
		fsm = new FSM();
		fsm.pushState(new IdleState(this));
		
		health = 2;
	}
	
	private function setAnim():Void {
		var assetName:String = "assets/images/zombie_slow";
		if (FlxRandom.chanceRoll())
			assetName += "_w";
		assetName += ".png";
		loadGraphic(assetName, true, 25, 24);
		animation.add("idle", [0, 2, 0, 2, 0, 2, 0, 5], 1, true);
		animation.add("run", [0, 1, 2, 3], 8, true);
		animation.add("attack", [4, 5, 6, 7, 8], 8, false);
		animation.add("startled", [9, 10, 10, 10], 8, false);
		animation.add("dead", [11], 8, false);
		
		animation.play("idle", true, -1);
		animation.randomFrame();
		
		width = 11;
		offset.x = 7;
		height = 6;
		offset.y = 16;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		if (FlxRandom.chanceRoll())
			facing = FlxObject.LEFT;
	}
	
	private function setPhys():Void {
		drag.set(RUNDRAG, RUNDRAG);
		maxVelocity.set(RUNMAX, RUNMAX);
	}
	
	override public function update():Void {
		if (alive)
			fsm.update();
		super.update();
	}
	
	override public function alert(Src:Enemy):Void {
		super.alert(Src);
		
		if (Src != null) {
			var srcPos:FlxPoint = Src.getMidpoint();
			var pos:FlxPoint = getMidpoint();
			
			if (pos.distanceTo(srcPos) <= ALERT_RANGE) {
				new FlxTimer(0.25, function(T:FlxTimer) {
					if (fsm.peak() == IdleState)
						fsm.pushState(new RunState(this));
				});
			}
		}
		else
			fsm.pushState(new RunState(this));
	}
}

class IdleState extends FSMState {
	
	public var TRIGGER_DIST:Int = 72;
	
	public var z:ZombieSlow;
	
	public function new(Z:ZombieSlow) {
		super();
		z = Z;
		if (z.animation.name != "idle")
			z.animation.play("idle");
	}
	
	override public function update():Void {
		super.update();
		
		var p:Player = Reg.s.p;
		var dist:Float = z.getMidpoint().distanceTo(p.getMidpoint());
		if (dist <= TRIGGER_DIST)
			fsm.pushState(new RunState(z));
	}
}

class RunState extends FSMState {
	
	public var RECALC_TRIGGER:Int = 24;
	public var ATTACK_TRIGGER:Int = 16;
	public var RUNSPEED:Int = 256;
	
	public var z:ZombieSlow;
	
	public function new(Z:ZombieSlow) {
		super();
		z = Z;
		
		//z.animation.play("startled");
	}
	
	override public function update():Void {
		super.update();
		
		//if (z.animation.name == "startled" && z.animation.finished) {
			//z.animation.play("idle");
		//}
		//else if (z.animation.name != "startled") {
			var p:Player = Reg.s.p;
			var pPos:FlxPoint = p.getMidpoint();
			var zPos:FlxPoint = z.getMidpoint();
			
			var vx:FlxVector = new FlxVector(pPos.x - zPos.x, pPos.y - zPos.y);
			vx = vx.normalize();
			vx = vx.scale(RUNSPEED);
			z.acceleration.copyFrom(vx);
			
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
				fsm.pushState(new AttackState(z));
		//}
	}
}

class AttackState extends FSMState {
	
	public var ATTACK_RANGE:Int = 16;
	
	public var z:ZombieSlow;
	
	public function new(Z:ZombieSlow) {
		super();
		z = Z;
		
		z.animation.play("attack");
		z.acceleration.set();
		
		var pPos:FlxPoint = Reg.s.p.getMidpoint();
		var zPos:FlxPoint = z.getMidpoint();
		
		if (pPos.x < zPos.x)
			z.facing = FlxObject.LEFT;
		else
			z.facing = FlxObject.RIGHT;
	}
	
	override public function update():Void {
		super.update();
		
		if (z.animation.finished) {
			var pPos:FlxPoint = Reg.s.p.getMidpoint();
			var zPos:FlxPoint = z.getMidpoint();
			
			if (zPos.distanceTo(pPos) <= ATTACK_RANGE) {
				if ((z.facing == FlxObject.LEFT && zPos.x >= pPos.x) ||
					(z.facing == FlxObject.RIGHT && zPos.x <= pPos.x)) {
						Reg.s.p.onHit();
					}
			}
			
			fsm.popState();
		}
	}
}