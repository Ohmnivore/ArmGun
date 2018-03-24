package ent;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Ohmnivore
 */
class HealthBar extends FlxGroup {
	
	public var shelve:FlxSprite;
	public var coffees:Array<FlxSprite> = [];
	
	public function new() {
		super();
		
		shelve = new FlxSprite(4, 21, "assets/images/hud_coffee_shelve.png");
		add(shelve);
		shelve.scrollFactor.set();
		
		var ix:Float = 5;
		for (i in 0...3) {
			var c:FlxSprite = new FlxSprite(ix, 3, "assets/images/hud_coffee_cup.png");
			add(c);
			coffees.push(c);
			c.scrollFactor.set();
			ix += c.width + 1;
		}
	}
	
	public function setLives(Lives:Int):Void {
		for (i in 0...coffees.length) {
			var c:FlxSprite = coffees[i];
			if (i < Lives) {
				c.color = 0xffffff;
				c.alpha = 1.0;
			}
			else {
				c.color = 0x45283c;
				c.alpha = 0.4;
			}
		}
	}
}