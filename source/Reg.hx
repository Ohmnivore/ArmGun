package;
import flixel.FlxG;

class Reg {
	
	static public var s:PlayState = null;
	static public var finalScore:Int = 0;
	static public var upgrades:Array<UpgradeInfo> = [];
	
	static public function init():Void {
		upgrades = [];
		
		upgrades.push(new UpgradeInfo("Super semi", 50, "Quick firing rate with moderate damage."));
		upgrades.push(new UpgradeInfo("Machine gun", 100, "Whirlwhind firing rate with low damage."));
		upgrades.push(new UpgradeInfo("Rocket launcher", 300, "Snail's pace firing rate with devastating area of effect damage."));
		upgrades.push(new UpgradeInfo("Mini-bomb ammo", 300, "Bullets deploy small time-activated bombs on impact."));
		upgrades.push(new UpgradeInfo("Freeze ammo", 100, "Bullets freeze enemies, slowing their movement."));
		upgrades.push(new UpgradeInfo("Morph ammo", 200, "Bullets have a chance to morph enemies into farm animals."));
		upgrades.push(new UpgradeInfo("Bouncing ammo", 200, "Bullets bounce off of objects."));
		upgrades.push(new UpgradeInfo("Piercing ammo", 200, "Bullets pass through enemies."));
		
		upgrades.sort(UpgradeInfo.compareCost);
	}
}

class UpgradeInfo {
	
	public var name:String;
	public var cost:Int;
	public var description:String;
	public var enabled:Bool;
	
	public function new(Name:String, Cost:Int, Description:String) {
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