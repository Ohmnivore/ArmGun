package ent.enemies;
import ent.FSM;
import ent.FSMState;
import ent.Player;
import ent.enemies.Enemy;
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
class Zombie extends Enemy {

	public var RUNDRAG:Int;
	public var RUNMAX:Int;
	public var ALERT_RANGE:Int;
	
	private var fsm:FSM;
	
	public function new(X:Float, Y:Float) {
		super(X, Y);
	}
	
	private function init(GfxAsset:String):Void {
		setAnim(GfxAsset);
		setPhys();
		fsm = new FSM();
		fsm.pushState(createIdleState(this));
	}
	
	private function setAnim(GfxAsset:String):Void {
		var assetName:String = GfxAsset;
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
						fsm.pushState(createRunState(this));
				});
			}
		}
		else
			fsm.pushState(createRunState(this));
	}
	
	public function createIdleState(Z:Zombie):FSMState {
		return new IdleState(Z);
	}
	
	public function createRunState(Z:Zombie):FSMState {
		return new RunState(Z);
	}
	
	public function createAttackState(Z:Zombie):FSMState {
		return new AttackState(Z);
	}
}

class IdleState extends FSMState {
	
	public var TRIGGER_DIST:Int = 72;
	
	public var z:Zombie;
	
	public function new(Z:Zombie) {
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
			fsm.pushState(z.createRunState(z));
	}
}

class RunState extends FSMState {
	
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
			fsm.pushState(z.createAttackState(z));
	}
}

class AttackState extends FSMState {
	
	public var ATTACK_RANGE:Int = 16;
	
	public var z:Zombie;
	
	public function new(Z:Zombie) {
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