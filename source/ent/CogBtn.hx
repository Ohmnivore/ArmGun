package ent;
import flixel.ui.FlxButton;

/**
 * ...
 * @author ...
 */
class CogBtn extends FlxButton {

	public function new() {
		super(96, 6);
		
		scrollFactor.set();
		
		loadGraphic('assets/images/cog_btn.png', true, 50, 34);
	}
}