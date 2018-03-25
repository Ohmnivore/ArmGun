package;

import ent.BloodSplatter;
import ent.CogBtn;
import ent.Cursor;
import ent.ESpawn;
import ent.HealthBar;
import ent.Player;
import ent.Score;
import ent.ZeldaDrawGroup;
import ent.enemies.Enemy;
import ent.wep.Weapon;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;
import util.OgmoLoader;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	
	public var numEnemies:Int = 0;
	
	public var p:Player;
	public var s:Score;
	public var healthBar:HealthBar;
	public var cogBtn:CogBtn;
	public var cursor:Cursor;
	
	public var map:FlxTilemap;
	public var ents:ZeldaDrawGroup;
	public var actors:FlxGroup;
	public var obstacles:FlxGroup;
	public var emitters:FlxGroup;
	public var bullets:FlxGroup;
	public var enemies:FlxTypedGroup<Enemy>;
	public var hud:FlxGroup;
	
	private var transitioningToGameOver:Bool;
	
	override public function create():Void {
		super.create();
		
		Reg.init();
		Reg.s = this;
		
		BloodSplatter.reset();
		
		FlxG.camera.fade(0xff000000, 0.5, true);
		
		transitioningToGameOver = false;
		
		FlxG.mouse.visible = false;
		FlxG.camera.bgColor = 0xff222034;
		actors = new FlxGroup();
		obstacles = new FlxGroup();
		emitters = new FlxGroup();
		bullets = new FlxGroup();
		enemies = new FlxTypedGroup<Enemy>();
		actors.add(enemies);
		
		var ol:OgmoLoader = new OgmoLoader(getMapString());
		map = ol.floor;
		add(map);
		map.tileScaleHack = 1.03;
		FlxG.worldBounds.set(map.x - FlxG.width, map.y - FlxG.height,
			map.x + map.width * 2, map.y + map.height * 2);
		
		ents = new ZeldaDrawGroup();
		add(ents);
		
		for (e in ol.ents) {
			ents.add(e);
			var c:Class<FlxBasic> = Type.getClass(e);
			if (c == ent.Spawn) {
				var s:ent.Spawn = cast e;
				p = new Player(s.x, s.y);
				p.cameraFollow();
				p.cameraCenter();
			}
		}
		ents.add(p);
		actors.add(p);
		
		hud = new FlxGroup();
		add(hud);
		healthBar = new HealthBar();
		hud.add(healthBar);
		cogBtn = new CogBtn();
		hud.add(cogBtn);
		s = new Score();
		hud.add(s);
		
		p.weapon = new Weapon(p);
		
		cursor = new Cursor();
		add(cursor);
	}
	
	private function getMapString():String {
		//return Assets.getText("assets/data/test.oel");
		//return Assets.getText("assets/data/test2.oel");
		return Assets.getText("assets/data/test3.oel");
	}

	override public function update():Void {
		super.update();
		
		FlxG.collide(actors, actors);
		FlxG.collide(actors, obstacles);
		FlxG.collide(obstacles, obstacles);
		FlxG.collide(emitters, obstacles);
		FlxG.collide(bullets, enemies, enemyHit);
		FlxG.collide(bullets, obstacles);
		FlxG.collide(ents, map);
		
		handleGeneralInput();
		pollGameOver();
		
		ESpawn.updateSpawns(s.totalScore);
	}
	
	override public function draw():Void {
		updateCursorVisibility();
		
		super.draw();
	}
	
	private function enemyHit(Bullet:FlxBasic, Enem:FlxBasic):Void {
		var e:Enemy = cast Enem;
		e.onHit(cast Bullet);
	}
	
	private function handleGeneralInput():Void {
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
		else if (FlxG.keys.justPressed.F12) // Hack
			s.score += 500;
		#if sys
		else if (FlxG.keys.justPressed.ESCAPE)
			Sys.exit(0);
		#end
	}
	
	private function pollGameOver():Void {
		if (Reg.s.healthBar.lives <= 0 && !transitioningToGameOver) {
			transitioningToGameOver = true;
			p.alive = false;
			
			Reg.finalScore = s.totalScore;
			
			FlxG.camera.fade(0xff000000, 1.5, false, function() {
				FlxG.switchState(new GameOverState());
			});
		}
	}
	
	private function updateCursorVisibility():Void {
		// Substates will have their own cursors, so hide this one
		cursor.visible = subState == null;
		cursor.update();
	}
}