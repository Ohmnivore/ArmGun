package ent.wep;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */

class Weapon {
	
	public var p:FlxSprite;
	
	public var dmg:Float = 1;
	public var reloadTime:Float = 0.5;
	
	private var reload:FlxTimer;
	
	public function new(P:FlxSprite) {
		p = P;
		
		reload = new FlxTimer(reloadTime);
	}
	
	public function update():Void {
		if (FlxG.mouse.justPressed) {
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
			
			var cd = new Bullet(dmg);
			cd.fireTowards(p, Delta.x, Delta.y);
		}
	}
}