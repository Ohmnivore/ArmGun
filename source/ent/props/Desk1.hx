package ent.props;

/**
 * ...
 * @author Ohmnivore
 */
class Desk1 extends Prop {
	
	public function new(X:Float, Y:Float) {
		super("desk1", X, Y);
		addPerspectiveOffset(19);
	}	
}