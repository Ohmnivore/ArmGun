package;
import ent.Cursor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import Reg.UpgradeInfo;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class ShopState extends FlxSubState {

	private var bg:FlxSprite;
	private var mainGroup:FlxGroup;
	private var scoreBtn:FlxButton;
	
	override public function create():Void {
		super.create();
		
		var overflow:Int = 16;
		bg = new FlxSprite();
		add(bg);
		bg.scrollFactor.set();
		bg.x = -overflow;
		bg.y = -overflow;
		bg.makeGraphic(FlxG.width + overflow * 2, FlxG.height + overflow * 2, 0xff000000);
		bg.alpha = 0.0;
		
		FlxTween.tween(bg, { "alpha": 0.8 }, 0.5, { ease: FlxEase.cubeIn, complete: function(T:FlxTween) {
			init();
		}});
		
		mainGroup = new FlxGroup();
		add(mainGroup);
		
		add(new Cursor());
	}
	
	private function init():Void {
		var description:FlxText = new FlxText();
		mainGroup.add(description);
		description.scrollFactor.set();
		UIUtils.setLabelGfx(description);
		
		var upgradeBtns:Array<UpgradeButton> = [];
		
		for (i in 0...Reg.upgrades.length) {
			var upgrade = Reg.upgrades[i];
			var btn = new UpgradeButton(upgrade, description, warnCallback);
			mainGroup.add(btn);
			upgradeBtns.push(btn);
		}
		
		organizeUpgradeBtns(upgradeBtns);
		
		///////////////////////////////////////////////////////////////////////
		
		var closeBtn = new FlxButton(0, 0, "Close", onCloseBtn);
		mainGroup.add(closeBtn);
		UIUtils.setButtonGfx(closeBtn);
		UIUtils.centerScreenX(closeBtn);
		closeBtn.y = 6;
		
		scoreBtn = new FlxButton(0, 0, "0");
		mainGroup.add(scoreBtn);
		UIUtils.setButtonGfx(scoreBtn);
		scoreBtn.active = false;
		scoreBtn.x = FlxG.width - scoreBtn.width - 6;
		scoreBtn.y = 6;
	}
	
	private function organizeUpgradeBtns(btns:Array<UpgradeButton>):Void {
		var rowSize:Int = 3;
		var stepX:Int = Math.floor(FlxG.width / (rowSize + 1));
		var stepY:Int = 32;
		var offsetY:Int = 64;
		
		for (i in 0...btns.length) {
			var row = i % rowSize;
			var col = Math.floor(i / rowSize);
			
			var btn = btns[i];
			var midX:Int = (row + 1) * stepX;
			btn.x = midX - btn.width / 2.0;
			btn.y = col * stepY + offsetY;
		}
	}
	
	private function onCloseBtn():Void {
		mainGroup.visible = false;
		active = false;
		
		FlxTween.tween(bg, { "alpha": 0.0 }, 0.5, { ease: FlxEase.cubeIn, complete: function(T:FlxTween) {
			close();
		}});
	}
	
	private function warnCallback(WarningText:String):Void {
		mainGroup.add(new WarningMsg(WarningText));
	}
	
	override public function update():Void {
		if (scoreBtn != null) { // Skip while waiting for init()
			scoreBtn.text = Std.string(Reg.s.s.score);
		}
		
		super.update();
	}
}

class UpgradeButton extends FlxButton {
	
	private var info:UpgradeInfo;
	private var descriptionLabel:FlxText;
	private var warnCallback:String->Void;
	
	public function new(Info:UpgradeInfo, DescriptionLabel:FlxText, WarnCallback:String->Void, X:Float = 0, Y:Float = 0) {
		info = Info;
		descriptionLabel = DescriptionLabel;
		warnCallback = WarnCallback;
		
		var t = info.name + " > (" + Std.string(info.cost) + ")";
		
		super(X, Y, t, onClick);
		UIUtils.setButtonGfx(this);
		loadGraphic("assets/images/big_btn.png", true, 140, 20);
	}
	
	override public function update():Void {
		if (info.enabled) {
			label.color = 0xff00ff00;
		}
		
		super.update();
		
		if (status != FlxButton.NORMAL) {
			descriptionLabel.text = info.description;
			UIUtils.centerScreenX(descriptionLabel);
			descriptionLabel.y = FlxG.height - descriptionLabel.height - 6;
		}
	}
	
	private function onClick():Void {
		if (!info.enabled) {
			if (Reg.s.s.score - info.cost >= 0) {
				info.enabled = true;
				Reg.s.s.score -= info.cost;
			}
			else {
				warnCallback("Insufficient funds. Eliminate intruders to acquire funds.");
			}
		}
		else {
			warnCallback("This upgrade has already been purchased.");
		}
	}
}

class WarningMsg extends FlxText {
	
	static private var curMsg:WarningMsg;
	
	private var destroyTimer:FlxTimer;
	
	public function new(WarningText:String) {
		if (curMsg != null) {
			curMsg.kill();
			curMsg.destroy();
			curMsg = null;
		}
		
		super(0, 0, 0, WarningText);
		scrollFactor.set();
		UIUtils.setLabelGfx(this);
		color = 0xffff0000;
		setBorderStyle(FlxText.BORDER_OUTLINE, 0x000000);
		
		UIUtils.centerScreenX(this);
		UIUtils.centerScreenY(this);
		
		destroyTimer = new FlxTimer(2.0, function(T:FlxTimer) {
			kill();
			destroy();
		});
		
		curMsg = this;
	}
	
	override public function destroy():Void {
		destroyTimer.cancel();
		
		super.destroy();
	}
}