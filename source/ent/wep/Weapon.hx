package ent.wep;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author Ohmnivore
 */

class Weapon {
	
	public var p:FlxSprite;
	
	public var effectChance:Float = 1.0;
	public var dmg:Float = 1.0;
	public var reloadTime:Float = 0.5;
	public var bounce:Float = 0.0;
	public var freeze:Float = 0.0;
	public var speed:Float = 256.0;
	public var morph:Float = 0.0;
	public var shotgun:Bool = false;
	
	private var reload:FlxTimer;
	
	public function new(P:FlxSprite) {
		p = P;
		
		reload = new FlxTimer(reloadTime);
	}
	
	public function update():Void {
		if (FlxG.mouse.pressed && !Reg.s.cogBtn.containsMouse()) {
			fire(new FlxPoint(FlxG.mouse.x - p.x, FlxG.mouse.y - p.y));
		}
	}
	
	private function fire(Delta:FlxPoint):Void {
		if (reload.finished) {
			reload.start(reloadTime);
			
			if (Delta.x < 0)
				p.facing = FlxObject.LEFT;
			else
				p.facing = FlxObject.RIGHT;
			
			var dir = new FlxVector();
			dir.copyFrom(Delta);
			dir.normalize();
			
			var bullet = new Bullet();
			setBulletProperties(bullet);
			bullet.fireTowards(p, dir);
			
			if (shotgun) {
				var bullet2 = new Bullet();
				setBulletProperties(bullet2);
				dir.rotateByDegrees(-15.0);
				bullet2.fireTowards(p, dir);
				
				var bullet3 = new Bullet();
				setBulletProperties(bullet3);
				dir.rotateByDegrees(30.0);
				bullet3.fireTowards(p, dir);
			}
		}
	}
	
	private function setBulletProperties(B:Bullet):Void {
		B.dmg = dmg;
		B.speed = speed;
		B.elasticity = bounce;
		B.freeze = freeze;
		B.morph = morph;
		B.effectChance = effectChance;
	}
}