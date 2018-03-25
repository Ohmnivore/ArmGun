package;
import flixel.FlxG;

class Reg {
	
	static public var s:PlayState = null;
	static public var finalScore:Int = 0;
	static public var upgrades:Array<UpgradeInfo> = [];
	
	///////////////////////////////////////////////////////////////////////////
	
	static public function init():Void {
		upgrades = [];
		
		upgrades.push(new UpgradeInfo(enableSuperSemi, "Super semi", 50, "Quick firing rate with moderate damage."));
		upgrades.push(new UpgradeInfo(enableMachineGun, "Machine gun", 100, "Whirlwhind firing rate with low damage."));
		upgrades.push(new UpgradeInfo(enableFreezeAmmo, "Freeze ammo", 30, "Bullets freeze enemies, slowing their movement."));
		upgrades.push(new UpgradeInfo(enableMorphAmmo, "Morph ammo", 25, "Bullets have a chance to morph enemies into farm animals."));
		upgrades.push(new UpgradeInfo(enableBouncingAmmo, "Bouncing ammo", 20, "Bullets bounce off of objects."));
		upgrades.push(new UpgradeInfo(enableShotgunAmmo, "Shotgun ammo", 125, "Bullets are fired in three directions at once."));
		
		upgrades.sort(UpgradeInfo.compareCost);
	}
	
	static private function enableSuperSemi():Void {
		s.p.weapon.dmg = 0.75;
		s.p.weapon.effectChance = 0.75;
		s.p.weapon.reloadTime = 0.25;
		s.p.weapon.speed = 300.0;
	}
	
	static private function enableMachineGun():Void {
		s.p.weapon.dmg = 0.15;
		s.p.weapon.effectChance = 0.4;
		s.p.weapon.reloadTime = 0.1;
		s.p.weapon.speed = 200.0;
	}
	
	static private function enableFreezeAmmo():Void {
		s.p.weapon.freeze = 0.5;
	}
	
	static private function enableMorphAmmo():Void {
		s.p.weapon.morph = 0.7;
	}
	
	static private function enableBouncingAmmo():Void {
		s.p.weapon.bounce = 0.5;
	}
	
	static private function enableShotgunAmmo():Void {
		s.p.weapon.shotgun = true;
	}
}

class UpgradeInfo {
	
	public var enableCallback:Void->Void;
	public var name:String;
	public var cost:Int;
	public var description:String;
	public var enabled:Bool;
	
	public function new(EnableCallback:Void->Void, Name:String, Cost:Int, Description:String) {
		enableCallback = EnableCallback;
		name = Name;
		cost = Cost;
		description = Description;
		enabled = false;
	}
	
	public static function compareCost(A:UpgradeInfo, B:UpgradeInfo):Int {
		if (A.cost > B.cost)
			return 1;
		else if (A.cost < B.cost)
			return -1;
		else
			return 0;
	}
}