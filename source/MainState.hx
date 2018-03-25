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
class MainState extends FlxState {

	override public function create():Void {
		super.create();
		
		FlxG.mouse.visible = false;
		FlxG.camera.bgColor = 0xff000000;
		FlxG.camera.fade(0xff000000, 0.5, true);
		
		var t1 = new FlxText(0, 0, 0, "[ Welcome to ArmGun ]");
		add(t1);
		UIUtils.centerScreenX(t1);
		
		var t2 = new FlxText(0, 0, 0, "[ Upgrade your ArmGun with funds ]      [ Eliminate intruders to acquire funds ]​");
		add(t2);
		UIUtils.centerScreenX(t2);
		UIUtils.centerScreenY(t2);
		
		t1.y = t2.y - t1.height - UIUtils.MARGIN;
		
		var t3 = new FlxText(0, 0, 0, "[ Arrows/WASD to move ]      [ Space/Tab/F to open/close shop ]      [ Mouse to aim/shoot ]");
		add(t3);
		UIUtils.centerScreenX(t3);
		t3.y = FlxG.height - t3.height - 6;
		
		var btn = new FlxButton(0, 0, "Start", function() {
			FlxG.camera.fade(0xff000000, 0.5, false, function() {
				FlxG.switchState(new PlayState());
			});
		});
		add(btn);
		UIUtils.setButtonGfx(btn);
		btn.label.color = 0xff00ff00;
		UIUtils.centerScreenX(btn);
		btn.y = t2.y + t2.height + UIUtils.MARGIN * 3;
		
		// Keep the cursor on top of the other elements
		add(new Cursor());
	}
}