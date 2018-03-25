package ent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Ohmnivore
 */
class Cursor extends FlxSprite {
	
	public function new() {
		super(0, 0);
		loadGraphic("assets/images/cursor.png", true, 24, 24);
		animation.add("bounce", [0, 1], 1, true);
		animation.play("bounce");
		
		setPosFromMouse();
	}
	
	override public function update():Void {
		setPosFromMouse();
		
		super.update();
	}
	
	private function setPosFromMouse():Void {
		x = FlxG.mouse.x - width / 2;
		y = FlxG.mouse.y - height / 2;
	}
}