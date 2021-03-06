package ent.enemies;
/**
 * ...
 * @author Ohmnivore
 */
class ZombieSlow extends Zombie {

	public function new(X:Float, Y:Float) {
		super(X, Y);
		
		points = 5;
		health = 2;
		
		RUNDRAG = 1024;
		RUNMAX = 144;
		ALERT_RANGE = 32;
		
		init("assets/images/zombie_slow");
	}
}