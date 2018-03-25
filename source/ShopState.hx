package;
import ent.Cursor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ...
 */
class ShopState extends FlxSubState {

	private var bg:FlxSprite;
	
	override public function create():Void {
		super.create();
		
		var overflow:Int = 16;
		bg = new FlxSprite();
		add(bg);
		bg.scrollFactor.set();
		bg.x = -overflow;
		bg.y = -overflow;
		bg.makeGraphic(FlxG.width + overflow * 2, FlxG.height + overflow * 2, 0xff000000);
		bg.alpha = 0.0;
		
		FlxTween.tween(bg, { "alpha": 0.8 }, 0.5, { ease: FlxEase.cubeIn, complete: function(T:FlxTween) {
			init();
		}});
		
		add(new Cursor());
	}
	
	private function init():Void {
		
	}
}