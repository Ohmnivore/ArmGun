package ent;
import ent.Player.DustTrail;
import ent.wep.Weapon;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxVector;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends FlxSprite {
	
	public static var RUNSPEED:Int = 128;
	public static var VELDRAG:Float = 0.85;
	public static var IDLETHRESHOLD:Float = 12;
	
	public var curWeap:Weapon;
	
	public var dustTrail:DustTrail;
	public var gunTrail:GunTrail;
	
	public var hp(get, set):Int;
	private var _hp:Int = 3;
	public function get_hp():Int {
		return _hp;
	}
	public function set_hp(HP:Int):Int {
		_hp = HP;
		if (_hp > 3)
			_hp = 3;
		else if (_hp < 0)
			_hp = 0;
		Reg.s.healthBar.setLives(_hp);
		return _hp;
	}
	
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		setAnim();
		setPhys();
		
		dustTrail = new DustTrail(this);
		gunTrail = new GunTrail(this);
	}
	
	private function setAnim():Void {
		loadGraphic("assets/images/futurebot.png", true, 25, 24);
		animation.add("idle", [4, 5], 1, true);
		animation.add("run", [0, 1, 2, 3], 12, true);
		animation.add("run_reverse", [3, 2, 1, 0], 12, true);
		animation.play("idle");
		
		width = 11;
		offset.x = 7;
		height = 6;
		offset.y = 16;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
	}
	
	private function setPhys():Void {
		
	}
	
	public function cameraCenter():Void {
		FlxG.camera.focusOn(getMidpoint());
		var scrollTarget:FlxPoint = Reflect.field(FlxG.camera, "_scrollTarget"); // ugly but necessary
		scrollTarget.set(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
	}
	
	public function cameraFollow():Void {
		FlxG.camera.follow(this, FlxCamera.STYLE_TOPDOWN_TIGHT);
		FlxG.camera.followLerp = 8.0;
	}
	
	override public function update():Void {
		updateAnim();
		updateControls();
		super.update();
	}
	
	private function updateControls():Void {
		var vx:FlxVector = new FlxVector(0, 0);
		
		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
			vx.x = -1;
		else if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
			vx.x = 1;
		
		if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)
			vx.y = -1;
		else if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN)
			vx.y = 1;
		
		if (vx.x != 0.0 || vx.y != 0.0) {
			vx = vx.normalize();
			vx = vx.scale(RUNSPEED);
			velocity.copyFrom(vx);
		}
		else {
			velocity.x = velocity.x * VELDRAG;
			velocity.y = velocity.y * VELDRAG;
		}
		
		curWeap.update();
	}
	
	private function updateAnim():Void {
		if (FlxG.mouse.x < x + width / 2)
			facing = FlxObject.LEFT;
		else
			facing = FlxObject.RIGHT;
		
		if (Math.abs(velocity.x) < IDLETHRESHOLD && Math.abs(velocity.y) < IDLETHRESHOLD)
			animation.play("idle");
		else {
			if (facing == FlxObject.LEFT && velocity.x < 0)
				animation.play("run");
			else if (facing == FlxObject.RIGHT && velocity.x > 0)
				animation.play("run");
			else
				animation.play("run_reverse");
		}
	}
	
	public function onHit():Void {
		if (!FlxSpriteUtil.isFlickering(this)) {
			hp--;
			FlxSpriteUtil.flicker(this, 1, 0.04);
			FlxG.camera.shake(0.005, 0.5);
			
			var mid:FlxPoint = getMidpoint();
			new BloodSplatter(mid.x, mid.y);
		}
	}
}

class DustTrail extends FlxEmitter {

	private var parent:FlxSprite;
	
	public function new(P:FlxSprite) {
		super(0, 0, 24);
		parent = P;
		
		for (i in 0...maxSize) {
			var p:FlxParticle = new FlxParticle();
			var col = FlxRandom.getObject([0xff888888, 0xff999999, 0xffaaaaaa]);
			p.makeGraphic(3, 3, col);
			p.solid = false;
			add(p);
		}
		
		setRotation(0, 0);
		particleDrag.set(180, 180);
		setAlpha(0.9, 1, 0, 0);
		setScale(1, 1, 2, 3);
		gravity = -30.0;
		start(false, 0.33, 0.1, 0, 0.1);
		Reg.s.ents.add(this);
	}
	
	override public function update():Void {
		var mult = 0.5;
		var velUp = -10.0;
		setXSpeed(-parent.velocity.x * mult, -parent.velocity.x * mult);
		setYSpeed(-parent.velocity.y * mult + velUp, -parent.velocity.y * mult + velUp);
		
		setPosition(parent.x + parent.width / 2.0, parent.y + parent.height);
		
		on = Math.abs(parent.velocity.x) > Player.IDLETHRESHOLD || Math.abs(parent.velocity.y) > Player.IDLETHRESHOLD;
		
		super.update();
	}
}

class GunTrail extends FlxEmitter {

	private var parent:FlxSprite;
	
	public function new(P:FlxSprite) {
		super(0, 0, 24);
		parent = P;
		
		for (i in 0...maxSize) {
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(2, 2, 0xff5fcde4);
			p.solid = false;
			add(p);
		}
		
		setRotation(0, 0);
		particleDrag.set(180, 180);
		setAlpha(0.9, 1, 0, 0);
		setXSpeed();
		setYSpeed(-20, -20);
		gravity = -10.0;
		start(false, 0.7, 0.2, 0, 0.1);
		Reg.s.ents.add(this);
	}
	
	override public function update():Void {
		var pos = new FlxPoint();
		
		if (parent.facing == FlxObject.LEFT) {
			pos.x = parent.x - 4;
		}
		else {
			pos.x = parent.x + 15;
		}
		
		pos.y = parent.y - 1;
		
		if (parent.animation.curAnim.curFrame % 1 == 0) {
			pos.y -= 1;
		}
		
		setPosition(pos.x, pos.y);
		
		super.update();
	}
}