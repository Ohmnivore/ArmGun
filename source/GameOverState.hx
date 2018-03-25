package;
import ent.Cursor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class GameOverState extends FlxState {

	override public function create():Void {
		super.create();
		
		FlxG.camera.bgColor = 0xff000000;
		FlxG.camera.fade(0xff000000, 0.5, true);
		
		var t1 = new FlxText(0, 0, 0, "Critical structure damage. Powering down...");
		add(t1);
		UIUtils.centerScreenX(t1);
		
		var t2 = new FlxText(0, 0, 0, "Score: " + Std.string(Reg.finalScore));
		add(t2);
		UIUtils.centerScreenX(t2);
		UIUtils.centerScreenY(t2);
		
		t1.y = t2.y - t1.height - UIUtils.MARGIN;
		
		var btn = new FlxButton(0, 0, "Play again", function() {
			FlxG.camera.fade(0xff000000, 0.5, false, function() {
				FlxG.switchState(new PlayState());
			});
		});
		add(btn);
		UIUtils.setButtonGfx(btn);
		UIUtils.centerScreenX(btn);
		btn.y = t2.y + t2.height + UIUtils.MARGIN * 3;
		
		// Keep the cursor on top of the other elements
		add(new Cursor());
	}
}