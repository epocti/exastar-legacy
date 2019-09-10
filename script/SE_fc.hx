package scripts;

import scripts.assets.Assets;
import scripts.tools.EZImgInstance;
import scripts.id.FontID;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import openfl.events.KeyboardEvent;
import motion.Actuate;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import scripts.tools.Util;
import scripts.Script_Emotive;
import scripts.id.FontID;

class SE_fc extends SceneScript {
	var nameBox:EZImgInstance = new EZImgInstance("g", true, "ui.fc.namebox.nameBox1");
	var nameBoxH:Float = 0;
	var tempFileName:String = "";
	var drawNameBox:Bool = false;
	var nameBoxOpacity:Float = 0;
	var difficultyBackH:Float = 0;
	var drawDifficulty:Bool = false;
	var difficultySel:Float = 2;
	var difficultyDisplay:String = "";
	var enableDifficultyInput:Bool = false;
	var keriiX:Float = 0;
	var keriiY:Float = -32;
	var finished:Bool = false;

	public function new(dummy:Int, dummy2:Engine) {
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
		addAnyKeyPressedListener(onPress);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== GAME THEORY: KERII KNOWS MORE THAN YOU THINK!!!!11ONE ====

	override public function init(){
		// Initial
		playSoundOnChannel(Assets.get("mus.fc"), 0);
		nameBox.setAlpha(0);
		nameBox.setOrigin("CENTER");
		nameBox.centerOnScreen(true, true);
		nameBox.enableAnimation("ui.fc.namebox.nameBox", 3, 100, true);
		keriiX = Util.getMidScreenX() - (getActor(1).getWidth() / 2);
		Script_Emotive.setAnim("fcKerii", "n", "d", false, false);

		// Kerii flies in
		runLater(1500, function(timeTask:TimedTask):Void {
			Actuate.tween(this, 2, {keriiX:Util.getMidScreenX() - (getActor(1).getWidth() / 2)}).ease(Quad.easeOut);
			Actuate.tween(this, 2, {keriiY:Util.getMidScreenY() - (getActor(1).getHeight() / 2)}).ease(Quad.easeOut);
			// Then goes up a bit
			runLater(2000, function(timeTask:TimedTask):Void {
				Actuate.tween(this, 1, {keriiY:(keriiY - 32)}).ease(Quad.easeInOut);
				runLater(1000, function(timeTask:TimedTask):Void { Actuate.tween(this, 1, {keriiY:(keriiY + 32)}).ease(Quad.easeInOut); }, null);
				// Then we repeat that again and again
				runPeriodically(2000, function(timeTask:TimedTask):Void {
					if(!finished){
						Actuate.tween(this, 1, {keriiY:(keriiY - 32)}).ease(Quad.easeInOut);
						runLater(1000, function(timeTask:TimedTask):Void { if(!finished) Actuate.tween(this, 1, {keriiY:(keriiY + 32)}).ease(Quad.easeInOut); }, null);
					}
				}, null);
				getActor(1).setAnimation("n_u");
				Script_Emotive.setAnim("fcKerii", "n", "u", false, false);
				// Introduction dialog
				runLater(750, function(timeTask:TimedTask):Void { dialog.core.Dialog.cbCall("dg_fcIntro", "style_main", this, "inputName"); }, null);
			}, null);
		}, null);

		// Music looping
		runLater(getSoundLengthForChannel(0) + 380, function(timeTask:TimedTask):Void {
			if(!finished) loopSoundOnChannel(Assets.get("mus.fc_loop"), 0);
		}, null);
	}

	public inline function update(elapsedTime:Float){
		// Resize the textbox if the text tries to escape
		// nameBox.setWidth(Std.int((getFont(FontID.MAIN).font.getTextWidth(Util.getAttr("fileName"))/Engine.SCALE * 100) / 64) + 60);
		nameBox.growTo(Std.int((getFont(FontID.MAIN).font.getTextWidth(Util.getAttr("fileName"))/Engine.SCALE * 100) / 64) + 60, 100, .15, Quad.easeOut);
		// Quirky difficulty name updating
		if(difficultySel == 0) difficultyDisplay = Util.getString("FC_DIFFICULTY_SUPEREASY");
		if(difficultySel == 1) difficultyDisplay = Util.getString("FC_DIFFICULTY_EASY");
		if(difficultySel == 2) difficultyDisplay = Util.getString("FC_DIFFICULTY_NORMAL");
		if(difficultySel == 3) difficultyDisplay = Util.getString("FC_DIFFICULTY_HARD");
		if(difficultySel == 4) difficultyDisplay = Util.getString("FC_DIFFICULTY_SUPERHARD");
		if(difficultySel == 5) difficultyDisplay = Util.getString("FC_DIFFICULTY_CUSTOM");
		// Move kerii to where she needs to be
		getActor(1).setX(keriiX);
		getActor(1).setY(keriiY);
	}

	public inline function draw(g:G){
		// Draw namebox stuff
		if(drawNameBox){
			g.alpha = nameBoxOpacity / 100;
			g.strokeColor = Utils.getColorRGB(0, 0, 0);
			// Draw indicator text
			g.setFont(getFont(FontID.MAIN));
			g.drawString(Util.getAttr("fileName"), (Util.getMidScreenX() - (g.font.font.getTextWidth(Util.getAttr("fileName"))/Engine.SCALE / 2)), ((Util.getMidScreenY() - (g.font.getHeight()/Engine.SCALE / 2)) + 1));
			g.drawString(Util.getString("FC_ENTERNAME"), ((getScreenWidth() / 2) - (g.font.font.getTextWidth(Util.getString("FC_ENTERNAME")) / Engine.SCALE / 2)), (getScreenHeight() / 3));
			if(Util.getAttr("controllerMode")) g.drawString(Util.getString("FC_ENTERNAME_CONTROLLERMODE"), (Util.getMidScreenX() - (g.font.font.getTextWidth(Util.getString("FC_ENTERNAME_CONTROLLERMODE"))/Engine.SCALE / 2)), (getScreenHeight() / 3) + 18);
		}
		// Draw difficulty box / text
		if(drawDifficulty){
			g.alpha = 1;
			g.fillColor = Utils.getColorRGB(0, 0, 0);
			g.strokeSize = 0;
			g.fillRect(0, Util.getMidScreenY() - (nameBoxH / 2), getScreenWidth(), nameBoxH);
			g.setFont(getFont(FontID.MAIN));
			g.drawString(Util.getString("FC_DIFFICULTY"), (Util.getMidScreenX() - (g.font.font.getTextWidth(Util.getString("FC_DIFFICULTY"))/Engine.SCALE / 2)), (getScreenHeight() / 3));
			g.setFont(getFont(FontID.MAIN_WHITE));
			g.drawString("<   " + difficultyDisplay + "   >", (Util.getMidScreenX() - (g.font.font.getTextWidth("<   " + difficultyDisplay + "   >")/Engine.SCALE / 2)), ((Util.getMidScreenY() - (g.font.getHeight()/Engine.SCALE / 2)) + 1));
		}
	}

	public inline function onPress(event:KeyboardEvent, list:Array<Dynamic>):Void {
		if(drawNameBox && !Util.inDialog()){
			if(event.keyCode == 8){
				playSoundOnChannel(Assets.get("sfx.key_backspace"), 1);
				Engine.engine.setGameAttribute("fileName", Util.getAttr("fileName").substring(0, Util.getAttr("fileName").length - 1));
			}
			else if(event.keyCode == 13){
				playSoundOnChannel(Assets.get("sfx.key_enter"), 1);
				completeNameInput();
			}
			else if((!(event.keyCode == 8) && !(event.keyCode == 13)) && (Util.getAttr("fileName").length <= 17)){
				if(event.keyCode == 32)
					playSoundOnChannel(Assets.get("sfx.key_space"), 1);
				else
					playSoundOnChannel(Assets.get("sfx.key" + randomInt(1,5)), 1);
				Engine.engine.setGameAttribute("fileName", (Util.getAttr("fileName") + ("" + charFromCharCode(event.charCode))));
			}
		}
		if(enableDifficultyInput){
			if(isKeyPressed("left") && (difficultySel - 1) >= 0) difficultySel -= 1;
			if(isKeyPressed("right") && (difficultySel + 1) <= 5) difficultySel += 1;
			if(event.keyCode == 90) completeDifficulty();
		}
	}

	// NAMEINPUT

	// Initial name input
	function inputName():Void {
		Script_Emotive.setAnim("fcKerii", "spin", "a", false, false);
		Actuate.tween(this, 4, {keriiX:(Util.getMidScreenX() - (getActor(1).getWidth()/2)) - 220}).ease(Quad.easeOut);
		runLater(4000, function(timeTask:TimedTask):Void { Script_Emotive.setAnim("fcKerii", "n", "u", false, false); }, null);
		nameBox.fadeTo(100, .5, Linear.easeNone);
		Actuate.tween(this, .5, {nameBoxOpacity:100}).ease(Linear.easeNone);
		drawNameBox = true;
		// TODO: only check on mobile
		showKeyboard();
	}

	// Recreate textbox, enable textdraw
	function retryName():Void {
		nameBox.fadeTo(100, .5, Linear.easeNone);
		Actuate.tween(this, .5, {nameBoxOpacity:100}).ease(Quad.easeOut);
		drawNameBox = true;
		// TODO: only check on mobile
		showKeyboard();
	}

	// Kill textbox, diable textdraw
	function completeNameInput():Void {
		// Quirky dialog text
		switch(Util.getAttr("fileName").toUpperCase()){
			case "": dialog.core.Dialog.cbCall("dg_fcNameMatch_empty", "style_main", this, "");
			// namematch kerii
			case "KERII": dialog.core.Dialog.cbCall("dg_fcNameMatch_kerii", "style_main", this, "");
			// namematch test
			case "TESTNAME": dialog.core.Dialog.cbCall("dg_fcNameMatch_test", "style_main", this, "");
			case "TEST NAME": dialog.core.Dialog.cbCall("dg_fcNameMatch_test", "style_main", this, "");
			case "COOL TEST NAME": dialog.core.Dialog.cbCall("dg_fcNameMatch_test", "style_main", this, "");
			// no namematch
			default: dialog.core.Dialog.cbCall("dg_fcConfirmName", "style_main", this, "");
		}
		nameBox.fadeTo(0, .5, Linear.easeNone);
		drawNameBox = false;
		hideKeyboard();
	}

	// DIFFICULTY

	// Show + enable difficulty input
	function showDifficulty():Void {
		drawDifficulty = true;
		enableDifficultyInput = true;
		Actuate.tween(this, .5, {nameBoxH:32}).ease(Quad.easeOut);
		Actuate.tween(this, .75, {keriiX:Util.getMidScreenX() - (getActor(1).getWidth() / 2)}).ease(Quad.easeOut);
		Actuate.tween(this, .75, {keriiY:80}).ease(Quad.easeOut);
	}

	// Reenable difficulty input
	function retryDifficulty():Void { enableDifficultyInput = true; }

	// Disable difficulty input
	function completeDifficulty():Void {
		dialog.core.Dialog.cbCall("dg_fcConfirmDifficulty", "style_main", this, "");
		enableDifficultyInput = false;
	}

	// Hide difficulty input
	function hideDifficulty():Void {
		Actuate.tween(this, .5, {nameBoxH:0}).ease(Quad.easeOut);
		runLater(500, function(timeTask:TimedTask):Void { drawDifficulty = false; }, null);
	}

	// le fin
	function finish():Void {
		Util.setAttr("bufferTransfer", "prologue");
		finished = true;
		Actuate.tween(this, 10, {keriiY:-48}).ease(Linear.easeNone);
		Script_Emotive.setAnim("fcKerii", "hSpin", "a", false, false);
		stopAllSounds();
		runLater(1, function(timeTask:TimedTask):Void {
			playSoundOnChannel(Assets.get("mus.gameBegin"), 0);
			switchScene(GameModel.get().scenes.get(66).getID(), createFadeOut(10.5, Utils.getColorRGB(255,255,255)), createFadeIn(0.01, Utils.getColorRGB(0,0,0)));
		}, null);
	}
}