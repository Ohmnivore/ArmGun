package ent;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxSort;

/**
 * ...
 * @author Ohmnivore
 */
class ZeldaDrawGroup extends FlxGroup {
	
	public var toDraw:Array<FlxObject>;
	
	override public function draw():Void {
		toDraw = [];
		pushToDrawArr(this);
		toDraw.sort(cast FlxSort.byY.bind(FlxSort.ASCENDING));
		
		for (obj in toDraw)
			obj.draw();
	}
	
	private function pushToDrawArr(B:FlxBasic):Void {
		if (Std.is(B, FlxTypedGroup)) {
			var g:FlxTypedGroup<FlxBasic> = cast B;
			
			var i:Int = 0;
			var basic:FlxBasic = null;
			while (i < g.length) {
				basic = g.members[i++];
				if (basic != null && basic.exists && basic.visible)
					pushToDrawArr(basic);
			}
		}
		else if (Std.is(B, FlxObject)) {
			toDraw.push(cast B);
		}
	}
}