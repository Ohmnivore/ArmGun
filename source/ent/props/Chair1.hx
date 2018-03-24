package ent.props;

/**
 * ...
 * @author Ohmnivore
 */
class Chair1 extends Prop {
	
	public function new(X:Float, Y:Float) {
		super("chair1", X, Y);
		addPerspectiveOffset(13);
		height -= 1;
		immovable = false;
		drag.x = drag.y = 192;
	}
}