package ent.wep;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class Weapon {
	
	static public var INFINITY_AMMO:Int = -1;
	
	public var p:FlxSprite;
	public var ammo:Int = 0;
	public var dmg:Int = 1;
	
	public function new(P:FlxSprite) {
		p = P;
		ammo = INFINITY_AMMO;
	}
	
	public function update():Void {
		
	}
}