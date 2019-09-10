package scripts.ui;

import scripts.saves.SaveManager;
import com.stencyl.behavior.TimedTask;
import openfl.events.KeyboardEvent;
import com.stencyl.graphics.G;
import scripts.id.FontID;
import com.stencyl.behavior.Script;
import motion.easing.Quad;
import motion.Actuate;
import scripts.tools.Util;
import scripts.tools.EZImgInstance;
import scripts.assets.Assets;
import scripts.Script_Emotive;

class UI_SaveBox {
	var enabled:Bool;
	var fileBox:EZImgInstance;
	var confirmBox:EZImgInstance;
	var bg:EZImgInstance;
	var selection:Int;
	var confirmation:Bool = false;
	var confirmationOpacity:Float = 0;
	var drawOpacity:Float = 0;
	var script:Script = new Script();
	var headerLine1:Array<String> = new Array<String>();
	var headerLine2:Array<String> = new Array<String>();
	var baseX:Float;

	public function new(){
		Util.enableInDialog();
		bg = new EZImgInstance("g", true, "ui.saveBox.bg");
		bg.setAlpha(0);

		fileBox = new EZImgInstance("g", true, "ui.saveBox.saveBox");
		fileBox.setAlpha(0);
		fileBox.centerOnScreen(true, false);
		fileBox.setY(Std.int(((Script.getScreenHeight() / 3) * 2) - (fileBox.getHeight() / 2)) + 8);
		baseX = fileBox.getX();

		if(Util.getAttr("lastSavedFile") != null) selection = Util.getAttr("lastSavedFile");
		else selection = 0;

		// Load header lines
		for(i in 0...5) headerLine1.push(AttributeSaving.loadData("headerLine1", i));
		for(i in 0...5) headerLine2.push(AttributeSaving.loadData("headerLine2", i));
	}

	// ========

	public function init(){
		// Draw calls
		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			g.setFont(Script.getFont(FontID.MAIN));
			g.alpha = drawOpacity;
			g.drawString("< " + (selection + 1) + " >", fileBox.getX() + 6, fileBox.getY() + 3);
			g.drawString(headerLine1[selection], fileBox.getX() + 6, fileBox.getY() + 16);
			g.drawString(headerLine2[selection], fileBox.getX() + 6, fileBox.getY() + 28);
			
			if(!Util.controllerMode) g.drawString(Util.getString("SAVEBOX_KEYS"), fileBox.getX() + fileBox.getWidth() - 6 - g.font.font.getTextWidth(Util.getString("SAVEBOX_KEYS")), fileBox.getY() + fileBox.getHeight() - 20);
			else {
				if(Util.controllerType == "ps") g.drawString(Util.BT_PS_0 + " Save - " + Util.BT_PS_1 + " Return", fileBox.getX() + fileBox.getWidth() - 6 - g.font.font.getTextWidth(Util.BT_PS_0 + " Save - " + Util.BT_PS_1 + " Return"), fileBox.getY() + fileBox.getHeight() - 20);
			}
			
			if(confirmation){
				g.alpha = confirmationOpacity;
				g.drawString(Util.getString("SAVEBOX_CONFIRM"), (confirmBox.getX() + confirmBox.getWidth() / 2) - (g.font.font.getTextWidth(Util.getString("SAVEBOX_CONFIRM")) / 2), confirmBox.getY() + 9);
				g.drawString(Util.getString("SAVEBOX_CONFIRMKEYS"), (confirmBox.getX() + confirmBox.getWidth() / 2) - (g.font.font.getTextWidth(Util.getString("SAVEBOX_CONFIRMKEYS")) / 2), confirmBox.getY() + 23);
			}
			g.alpha = drawOpacity;
			g.setFont(Script.getFont(FontID.MAIN_WHITE));
			g.drawString(Util.getString("SAVEBOX_TITLE"), Util.getMidScreenX() - (g.font.font.getTextWidth(Util.getString("SAVEBOX_TITLE")) / 2), Script.getScreenHeight() - 18);
		});
		// Keycontrols
		script.addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(enabled){
				if(Script.isKeyPressed("left") && (selection > 0 && !confirmation)){
					selection--;
					Script.playSoundOnChannel(Assets.get("sfx.pageFlipBackward"), 8);
					fileBox.slideTo(baseX - 16, fileBox.getY(), .1, Quad.easeInOut);
					Script.runLater(100, function(timeTask:TimedTask):Void {
						fileBox.slideTo(baseX, fileBox.getY(), .1, Quad.easeInOut);
					}, null);
				}
				else if(Script.isKeyPressed("right") && (selection < 4 && !confirmation)){
					selection++;
					Script.playSoundOnChannel(Assets.get("sfx.pageFlipForward"), 8);
					fileBox.slideTo(baseX + 16, fileBox.getY(), .1, Quad.easeInOut);
					Script.runLater(100, function(timeTask:TimedTask):Void {
						fileBox.slideTo(baseX, fileBox.getY(), .1, Quad.easeInOut);
					}, null);
				}
				else if(Script.isKeyPressed("action2")){
					if(!confirmation) hide();
					else {
						confirmBox.slideBy(0, 8, .25, Quad.easeOut);
						confirmBox.fadeTo(0, .25, Quad.easeOut);
						Actuate.tween(this, .25, {confirmationOpacity:0}).ease(Quad.easeOut);
						enabled = false;
						Script.runLater(250, function(timeTask:TimedTask):Void {
							confirmation = false;
							confirmBox = null;
							enabled = true;
						}, null);
					}
				}
				else if(Script.isKeyPressed("action1")){
					if(confirmation){
						SaveManager.SaveFile(selection);
						confirmBox.slideBy(0, 8, .25, Quad.easeOut);
						confirmBox.fadeTo(0, .25, Quad.easeOut);
						Actuate.tween(this, .25, {confirmationOpacity:0}).ease(Quad.easeOut);
						Script.runLater(500, function(timeTask:TimedTask):Void {
							confirmation = false;
							confirmBox = null;
						}, null);
						Util.setAttr("lastSavedFile", selection);
						Script.playSoundOnChannel(Assets.get("sfx.fileSave"), 8);
						Script.shoutToScene("onGameSave");
						hide();
					}
					else if(AttributeSaving.loadData("written", selection)){
						confirmation = true;
						Script.playSoundOnChannel(Assets.get("sfx.dialog_openPrompt"), 7);
						Actuate.tween(this, .25, {confirmationOpacity:1}).ease(Quad.easeOut);
						confirmBox = new EZImgInstance("g", true, "ui.saveBox.confirmBox");
						confirmBox.setAlpha(0);
						confirmBox.centerOnScreen(true, false);
						confirmBox.setY(fileBox.getY() + fileBox.getHeight() + 16);
						confirmBox.slideBy(0, -8, .25, Quad.easeOut);
						confirmBox.fadeTo(100, .25, Quad.easeOut);
						enabled = false;
						Script.runLater(250, function(timeTask:TimedTask):Void { enabled = true; }, null);
					}
					else {
						SaveManager.SaveFile(selection);
						Util.setAttr("lastSavedFile", selection);
						Script.playSoundOnChannel(Assets.get("sfx.fileSave"), 8);
						Script.shoutToScene("onGameSave");
						hide();
					}
				}
			}
		});
	}

	public function show(){
		Script_Emotive.setWalk("alex", false);
		Util.disableMovement();
		Actuate.tween(this, .5, {drawOpacity:1}).ease(Quad.easeOut);
		fileBox.slideBy(0, -8, .5, Quad.easeOut);
		fileBox.fadeTo(100, .5, Quad.easeOut);
		bg.fadeTo(100, 1, Quad.easeOut);
		enabled = true;
		for(i in 0...6) Util.fadeChannelTo(i, .5, 1, .25);
		Script.playSoundOnChannel(Assets.get("sfx.dialog_openPrompt"), 7);
		Util.setAttr("saveCooldown", true);
	}

	public function hide(){
		Util.enableMovement();
		Actuate.tween(this, .5, {drawOpacity:0}).ease(Quad.easeOut);
		fileBox.slideBy(0, 8, .5, Quad.easeOut);
		fileBox.fadeTo(0, .5, Quad.easeOut);
		bg.fadeTo(0, 1, Quad.easeOut);
		enabled = false;
		Util.disableInDialog();
		for(i in 0...6) Util.fadeChannelTo(i, .5, .25, 1);
		Script.runLater(500, function(timeTask:TimedTask):Void { Util.setAttr("saveCooldown", false); }, null);
	}
}
