package ent.enemies;
import ent.BloodSplatter;
import ent.enemies.Zombie.IdleState;
import ent.enemies.Zombie.MorphState;
import ent.wep.Bullet;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Enemy extends FlxSprite {

	public var points:Int;
	public var freeze:Float;
	public var path:FlxPath;
	
	private var fsm:FSM;
	
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		Reg.s.enemies.add(this);
		points = 0;
		freeze = 0.0;
		
		fsm = new FSM();
		
		Reg.s.numEnemies++;
	}
	
	public function onHit(B:Bullet):Void {
		var mid:FlxPoint = getMidpoint();
		new BloodSplatter(mid.x, mid.y);
		
		B.bounces++;
		health -= B.dmg;
		freeze += B.freeze * B.effectChance;
		freeze = Math.min(1.0, freeze);
		if (FlxRandom.floatRanged(0.0, 1.0) <= B.morph * B.effectChance) {
			if (fsm.peak() != MorphState) {
				fsm.pushState(new MorphState(cast this));
			}
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
		else {
			velocity.x *= 0.85;
			velocity.y *= 0.85;
		}
		
		super.update();
		
		freeze -= FlxG.elapsed * 0.2;
		freeze = Math.max(0.0, freeze);
	}
	
	private function die():Void {
		Reg.s.numEnemies--;
		
		if (fsm.peak() == MorphState) {
			var morphState:MorphState = cast fsm.popState();
			morphState.cancelMorph();
		}
		
		if (path != null)
			path.cancel();
		
		Reg.s.s.addScore(points);
		
		alive = false;
		acceleration.set();
		animation.play("dead", true);
		solid = false;
		
		new FlxTimer(5.0, function(T:FlxTimer) {
			FlxTween.tween(this, { "alpha": 0.0 }, 2, { ease: FlxEase.circOut });
		});
		
		var angleDelta:Float = 90;
		if (facing == FlxObject.RIGHT)
			angleDelta *= -1;
		FlxTween.angle(this, angle, angle + angleDelta, 0.2, { ease: FlxEase.bounceOut });
		
		FlxTween.tween(offset, { "y": offset.y + 8 }, 0.2, { ease: FlxEase.circOut, complete: function(T:FlxTween) {
			FlxTween.tween(offset, { "y": offset.y - 8 }, 0.2, { ease: FlxEase.bounceOut });
		}});
		
		new FlxTimer(7.1, function(T:FlxTimer) {
			Reg.s.ents.remove(this, true);
			Reg.s.enemies.remove(this, true);
			kill();
			destroy();
		});
	}
	
	public function alert(Src:Enemy):Void {
		
	}
}