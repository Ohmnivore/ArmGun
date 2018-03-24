package ent;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ohmnivore
 */
class HealthBar extends FlxGroup {
	
	public var shelve:FlxSprite;
	public var coffees:Array<FlxSprite> = [];
	
	public var lives:Int;
	
	public function new() {
		super();
		
		lives = 3;
		
		shelve = new FlxSprite(4, 21, "assets/images/hud_coffee_shelve.png");
		add(shelve);
		shelve.scrollFactor.set();
		
		var ix:Float = 5;
		for (i in 0...3) {
			var c:FlxSprite = new FlxSprite(ix, 3, "assets/images/hud_coffee_cup.png");
			add(c);
			coffees.push(c);
			c.scrollFactor.set();
			c.origin.set();
			ix += c.width + 1;
		}
	}
	
	public function decrement():Void {
		lives -= 1;
		
		if (lives >= 0) {
			var coffee = coffees[lives];
			
			FlxSpriteUtil.flicker(coffee, 0.6, 0.04, true, true, function(F:FlxFlicker) {
				coffee.color = 0x45283c;
				coffee.alpha = 0.4;
			});
			
			FlxTween.tween(coffee.scale, {"x": 1.5, "y": 1.5}, 0.25, { ease: FlxEase.quadOut, complete: function(T:FlxTween) {
				FlxTween.tween(coffee.scale, {"x": 1, "y": 1}, 0.25, { ease: FlxEase.circOut });
			}});
		}
	}
}