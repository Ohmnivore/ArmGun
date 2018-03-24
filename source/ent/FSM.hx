package ent;

/**
 * ...
 * @author Ohmnivore
 */
class FSM {

	private var states:Array<FSMState>;
	
	public function new() {
		states = [];
	}
	
	public function pushState(State:FSMState):Void {
		states.push(State);
		State.fsm = this;
	}
	
	public function popState():Null<FSMState> {
		return states.pop();
	}
	
	public function peak():Null<Class<FSMState>> {
		if (states.length > 0)
			return Type.getClass(states[states.length - 1]);
		else
			return null;
	}
	
	public function update():Void {
		if (states.length > 0)
			states[states.length - 1].update();
	}
}