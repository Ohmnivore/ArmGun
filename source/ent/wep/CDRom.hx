package ent.wep;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author Ohmnivore
 */

class CDRom extends Weapon {
	
	private var RELOAD_TIME:Float = 0.5;
	
	private var reload:FlxTimer;
	
	public function new(P:FlxSprite) {
		super(P);
		reload = new FlxTimer(RELOAD_TIME);
	}
	
	override public function update():Void {
		if ((ammo == Weapon.INFINITY_AMMO || ammo > 0) && FlxG.mouse.justPressed) {
			fire(new FlxPoint(FlxG.mouse.x - p.x, FlxG.mouse.y - p.y));
			Reg.s.s.addScore(10);
		}
	}
	
	private function fire(Delta:FlxPoint):Void {
		if (reload.finished) {
			reload.start(RELOAD_TIME);
			
			if (Delta.x < 0)
				p.facing = FlxObject.LEFT;
			else
				p.facing = FlxObject.RIGHT;
			
			var cd:CDRomBullet = new CDRomBullet(dmg);
			cd.fireTowards(p, Delta.x, Delta.y);
			
			if (ammo > 0)
				ammo--;
		}
	}
}

class CDRomBullet extends FlxSprite {
	
	public var dmg:Int;
	
	public function new(Dmg:Int, X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/cdrom.png");
		dmg = Dmg;
		height = 5;
		offset.y = 6;
		
		new CDRomTrail(this);
		Reg.s.ents.add(this);
		Reg.s.bullets.add(this);
	}
	
	override public function update():Void {
		if (isTouching(FlxObject.ANY)) {
			var explo:CDRomExplosion = new CDRomExplosion(this);
			Reg.s.ents.remove(this, true);
			Reg.s.bullets.remove(this, true);
			kill();
			destroy();
		}
		
		if (alive)
			super.update();
	}
	
	public function fireTowards(P:FlxObject, Dx:Float, Dy:Float):Void {
		var mid:FlxPoint = P.getMidpoint();
		x = mid.x - width / 2;
		y = mid.y - height / 2;
		
		var v:FlxVector = new FlxVector(Dx, Dy);
		v.normalize();
		v.scale(256);
		velocity.copyFrom(v);
	}
	
	public function fireTowardsMouse(P:FlxObject):Void {
		var mid:FlxPoint = P.getMidpoint();
		
		var dx:Float = FlxG.mouse.x - mid.x;
		var dy:Float = FlxG.mouse.y - mid.y;
		fireTowards(P, dx, dy);
	}
}

class CDRomTrail extends FlxEmitter {
	
	public var p:CDRomBullet;
	
	public function new(P:CDRomBullet) {
		super();
		p = P;
		
		for (i in 0...16) {
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(2, 2, 0xff9badb7);
			add(p);
		}
		
		setXSpeed();
		setYSpeed();
		setRotation();
		setAlpha(1.0, 1.0, 0.0, 0.0);
		start(false, 0.5, 0.08, 0, 0);
		
		Reg.s.ents.add(this);
	}
	
	override public function update():Void {
		var mid:FlxPoint = p.getMidpoint();
		mid.y -= 6;
		setPosition(mid.x, mid.y);
		
		if (p.alive)
			super.update();
		else {
			p = null;
			Reg.s.ents.remove(this, true);
			kill();
			destroy();
		}
	}
}

class CDRomExplosion extends FlxEmitter {
	
	public function new(P:CDRomBullet) {
		var mid:FlxPoint = P.getMidpoint();
		mid.y -= 6;
		super(mid.x, mid.y);
		
		var particleColors:Array<Int> = [0xffcbdbfc, 0xffcbdbfc, 0xff5fcde4, 0xffd77bba];
		for (c in particleColors) {
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(2, 2, c);
			add(p);
		}
		
		var s:Int = 256;
		setXSpeed(-s, s);
		setYSpeed( -s, s);
		setRotation();
		setAlpha(1, 1, 0.5, 0.5);
		
		start(true, 0.1, 0.1, 0, 0.1);
		new FlxTimer(0.2, function(T:FlxTimer):Void {
			Reg.s.ents.remove(this, true);
			Reg.s.emitters.remove(this, true);
			kill();
			destroy();
		});
		
		Reg.s.ents.add(this);
		Reg.s.emitters.add(this);
	}
}