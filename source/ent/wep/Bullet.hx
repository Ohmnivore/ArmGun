package ent.wep;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author ...
 */
class Bullet extends FlxSprite {
	
	public var dmg:Float;
	public var freeze:Float;
	
	private var bounces:Int = 0;
	
	public function new(Dmg:Float, X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/bullet.png");
		dmg = Dmg;
		height = 5;
		offset.y = 6;
		
		new BulletTrail(this);
		Reg.s.ents.add(this);
		Reg.s.bullets.add(this);
	}
	
	override public function update():Void {
		if (isTouching(FlxObject.ANY)) {
			if (bounces > 0 || elasticity == 0) {
				var explo:BulletExplosion = new BulletExplosion(this);
				Reg.s.ents.remove(this, true);
				Reg.s.bullets.remove(this, true);
				kill();
				destroy();
			}
			else {
				var v = new FlxVector();
				v.set(velocity.x, velocity.y);
				v = v.normalize();
				angle = v.degrees;
				
				bounces++;
			}
		}
		
		if (alive)
			super.update();
	}
	
	public function fireTowards(P:FlxObject, Dx:Float, Dy:Float):Void {
		var mid = P.getMidpoint();
		x = mid.x - width / 2;
		y = mid.y - height / 2;
		
		var v = new FlxVector(Dx, Dy);
		v.normalize();
		
		angle = v.degrees;
		
		v.scale(256);
		velocity.copyFrom(v);
	}
	
	public function fireTowardsMouse(P:FlxObject):Void {
		var mid = P.getMidpoint();
		
		var dx:Float = FlxG.mouse.x - mid.x;
		var dy:Float = FlxG.mouse.y - mid.y;
		fireTowards(P, dx, dy);
	}
}

class BulletTrail extends FlxEmitter {
	
	public var p:Bullet;
	
	public function new(P:Bullet) {
		super();
		p = P;
		
		for (i in 0...16) {
			var p = new FlxParticle();
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
		var mid = p.getMidpoint();
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

class BulletExplosion extends FlxEmitter {
	
	public function new(P:Bullet) {
		var mid = P.getMidpoint();
		mid.y -= 6;
		super(mid.x, mid.y);
		
		var particleColors:Array<Int> = [0xffcbdbfc, 0xffcbdbfc, 0xff5fcde4, 0xffd77bba];
		for (c in particleColors) {
			var p = new FlxParticle();
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