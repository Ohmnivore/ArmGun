package ent.enemies;
/**
 * ...
 * @author Ohmnivore
 */
class ZombieFast extends Zombie {

	public function new(X:Float, Y:Float) {
		super(X, Y);
		
		points = 10;
		health = 3;
		
		RUNDRAG = 1024;
		RUNMAX = 240;
		ALERT_RANGE = 32;
		
		init("assets/images/zombie_fast");
	}
	
	override public function setAnim(GfxAsset:String, FromMorph:Bool = false):Void {
		super.setAnim(GfxAsset, FromMorph);
		
		animation.get("attack").frameRate = 24;
	}
}