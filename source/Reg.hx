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
		upgrades.push(new UpgradeInfo(enableFreezeAmmo, "Freeze ammo", 100, "Bullets freeze enemies, slowing their movement."));
		upgrades.push(new UpgradeInfo(enableMorphAmmo, "Morph ammo", 200, "Bullets have a chance to morph enemies into farm animals."));
		upgrades.push(new UpgradeInfo(enableBouncingAmmo, "Bouncing ammo", 200, "Bullets bounce off of objects."));
		
		upgrades.sort(UpgradeInfo.compareCost);
	}
	
	static private function enableSuperSemi():Void {
		s.p.weapon.dmg = 0.75;
		s.p.weapon.reloadTime = 0.25;
	}
	
	static private function enableMachineGun():Void {
		s.p.weapon.dmg = 0.1;
		s.p.weapon.reloadTime = 0.1;
	}
	
	static private function enableFreezeAmmo():Void {
		s.p.weapon.freeze = 0.5;
	}
	
	static private function enableMorphAmmo():Void {
		// TODO
	}
	
	static private function enableBouncingAmmo():Void {
		s.p.weapon.bounce = 0.5;
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