package ent;
import flixel.FlxG;
import flixel.ui.FlxButton;

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
		Reg.s.openSubState(new ShopState());
	}
}