package ent.props;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class Prop extends FlxSprite {
	
	public function new(ImgPath:String, X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/" + ImgPath + ".png");
		immovable = true;
		Reg.s.obstacles.add(this);
	}
	
	public function addPerspectiveOffset(Offset:Float):Void {
		height -= Offset;
		offset.y += Offset;
		y += Offset;
	}
	
	public function setBaseHeight(Height:Float):Void {
		offset.y = height - Height;
		height = Height;
		y += offset.y;
	}
}