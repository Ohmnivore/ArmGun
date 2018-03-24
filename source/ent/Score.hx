package ent;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ...
 */
class Score extends FlxText {

	public static var MARGIN:Int = 4;
	
	public var score:Int = 0;
	
	private var tween:FlxTween;
	
	public function new() {
		super();
		
		font = "assets/1980XX.ttf";
		size = 32;
		color = 0xffffffff;
		setBorderStyle(FlxText.BORDER_OUTLINE_FAST, 0xff000000, 1, 1);
		
		scrollFactor.set();
	}
	
	public function addScore(Amount:Int):Void {
		score += Amount;
		
		if (tween != null) {
			tween.cancel();
			tween = null;
		}
		
		tween = FlxTween.tween(scale, {"x": 1.5, "y": 1.5}, 0.25, { ease: FlxEase.quadOut, complete: function(T:FlxTween) {
			tween = FlxTween.tween(scale, {"x": 1, "y": 1}, 0.25, { ease: FlxEase.circOut });
		}});
	}
	
	override public function update():Void {
		text = Std.string(score);
		
		x = Math.floor(FlxG.width - width * scale.x - MARGIN);
		
		super.update();
	}
}