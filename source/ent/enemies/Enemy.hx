package ent.enemies;
import ent.BloodSplatter;
import ent.enemies.Zombie.MorphState;
import ent.wep.Bullet;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Enemy extends FlxSprite {

	public var points:Int;
	public var freeze:Float;
	
	private var fsm:FSM;
	
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		Reg.s.enemies.add(this);
		points = 0;
		freeze = 0.0;
		
		fsm = new FSM();
	}
	
	public function onHit(B:Bullet):Void {
		var mid:FlxPoint = getMidpoint();
		new BloodSplatter(mid.x, mid.y);
		
		health -= B.dmg;
		freeze += B.freeze * B.dmg;
		freeze = Math.min(1.0, freeze);
		
		if (fsm.peak() != MorphState) {
			fsm.pushState(new MorphState(cast this));
		}
		
		if (health > 0) {
			FlxSpriteUtil.flicker(this, 0.5);
			alert(null);
		}
		else
			die();
		
		for (e in Reg.s.enemies)
			e.alert(this);
	}
	
	override public function update():Void {
		if (alive) {
			var col = 1.0 - freeze * 0.6;
			setColorTransform(col, col, 1.0);
			
			velocity.x *= (1.0 - freeze);
			velocity.y *= (1.0 - freeze);
		}
		
		super.update();
		
		freeze -= FlxG.elapsed * 0.2;
		freeze = Math.max(0.0, freeze);
	}
	
	private function die():Void {
		if (fsm.peak() == MorphState) {
			var morphState:MorphState = cast fsm.popState();
			morphState.cancelMorph();
		}
		
		Reg.s.s.addScore(points);
		
		alive = false;
		acceleration.set();
		animation.play("dead", true);
		solid = false;
		
		new FlxTimer(5.0, function(T:FlxTimer) {
			FlxTween.tween(this, { "alpha": 0 }, 2, { ease: FlxEase.circOut });
		});
		
		var angleDelta:Float = 90;
		if (facing == FlxObject.RIGHT)
			angleDelta *= -1;
		FlxTween.angle(this, angle, angle + angleDelta, 0.2, { ease: FlxEase.bounceOut });
		
		FlxTween.tween(offset, { "y": offset.y + 8 }, 0.2, { ease: FlxEase.circOut, complete: function(T:FlxTween) {
			FlxTween.tween(offset, { "y": offset.y - 8 }, 0.2, { ease: FlxEase.bounceOut });
		}});
		
		new FlxTimer(6.0, function(T:FlxTimer) {
			Reg.s.enemies.remove(this, true);
		});
	}
	
	public function alert(Src:Enemy):Void {
		
	}
}