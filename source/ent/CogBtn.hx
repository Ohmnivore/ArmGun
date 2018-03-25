package ent;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxPath;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class CogBtn extends FlxButton {

	public function new() {
		super(96, 6, "", onClick);
		
		scrollFactor.set();
		
		loadGraphic('assets/images/cog_btn.png', true, 50, 34);
	}
	
	public function containsMouse():Bool {
		return status != FlxButton.NORMAL;
	}
	
	private function onClick():Void {
		openShopState();
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.keys.justPressed.TAB || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.F)
			openShopState();
	}
	
	private function openShopState():Void {
		FlxTimer.manager.active = false;
		FlxPath.manager.active = false;
		
		Reg.s.openSubState(new ShopState());
	}
}