package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class UIUtils {

	static public inline var MARGIN = 8;
	
	static public function centerScreenX(obj:FlxObject) {
		obj.x = Math.round((FlxG.width - obj.width) / 2.0);
	}
	
	static public function centerScreenY(obj:FlxObject) {
		obj.y = Math.round((FlxG.height - obj.height) / 2.0);
	}
	
	static public function setButtonGfx(btn:FlxButton) {
		btn.loadGraphic('assets/images/btn.png', true, 80, 20);
		btn.labelAlphas = [1.0, 1.0, 1.0];
		btn.label.alpha = btn.labelAlphas[0];
		btn.labelOffsets = [FlxPoint.get(-1, 3), FlxPoint.get(-1, 3), FlxPoint.get(-1, 3)];
		setLabelGfx(btn.label);
	}
	
	static public function setLabelGfx(label:FlxText) {
		label.color = 0xffffffff;
	}
}