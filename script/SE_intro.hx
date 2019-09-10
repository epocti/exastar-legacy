package scripts;

import scripts.assets.Assets;
import scripts.gfx.GFX_Letterbox;
import scripts.tools.EZImgInstance;
import scripts.tools.Util;
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
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;
import scripts.id.FontID;

class SE_intro extends SceneScript {
	var redTintAmount:Float = 0.0;
	var drawTint:Bool = false;
	var drawBeam:Bool = false;
	var beamWidth:Float = 0.0;
	var dialogList:Array<String> = new Array<String>();
	var dialogLine:Int = 0;
	var textHeight:Float = 0.0;
	var currentDialogWords:Array<Dynamic>;
	var dLine1:String = "";
	var dLine2:String = "";
	var bars:GFX_Letterbox;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== This is the ExaStar, a star that does things (and has a cool name) ====

	override public function init(){
		// Set up dialog
		for(i in 1...5){ dialogList.push(Util.getString("INTRO_" + i)); }
		dialogList.push("");

		Engine.engine.setGameAttribute("bufferTransfer", "title");
		dialogLine = 5;
		// Particles
		runPeriodically(500, function(timeTask:TimedTask):Void { createRecycledActor(getActorType(474), -8, -24, Script.BACK); }, null);

		// Dialog loop
		runLater(3800, function(timeTask:TimedTask):Void {
			dialogLine = 0;
			// Split up and reconcat the text so it fits on 2 lines
			currentDialogWords = dialogList[dialogLine].split(" ");
			if(currentDialogWords.length > 11){
				for(i in 0...10) dLine1 = (dLine1 + (currentDialogWords[i] + " "));
				for(i in 0...currentDialogWords.length - 10) dLine2 = (dLine2 + currentDialogWords[i + 10] + " ");
			}
			else for(i in 0...currentDialogWords.length) dLine1 = (dLine1 + currentDialogWords[i] + " ");
			Actuate.tween(this, .5, {textHeight:5}).ease(Linear.easeNone);

			// Move text height
			runLater(5490, function(timeTask:TimedTask):Void { Actuate.tween(this, .5, {textHeight:0}).ease(Linear.easeNone); }, null);

			// Change dialog text and reformat
			runPeriodically(6000, function(timeTask:TimedTask):Void {
				if(dialogLine < 5){
					Actuate.tween(this, .5, {textHeight:5}).ease(Linear.easeNone);
					runLater(5490, function(timeTask:TimedTask):Void { Actuate.tween(this, .5, {textHeight:0}).ease(Linear.easeNone); }, null);
					dialogLine++;
					// Split up and reconcat the text so it fits on 2 lines
					currentDialogWords = dialogList[dialogLine].split(" ");
					dLine1 = "";
					dLine2 = "";
					if(currentDialogWords.length > 11){
						for(i in 0...10) dLine1 = (dLine1 + currentDialogWords[i] + " ");
						for(i in 0...(currentDialogWords.length - 10)) dLine2 = (dLine2 + currentDialogWords[i + 10] + " ");
					}
					else for(i in 0...currentDialogWords.length) dLine1 = (dLine1 + currentDialogWords[i] + " ");
				}
			}, null);

			// After the dialog is all complete, do this
			runLater(29000, function(timeTask:TimedTask):Void { shoutToScene("dialogComplete"); }, null);
		}, null);

		// End and go to the buffer
		runLater(42550, function(timeTask:TimedTask):Void {
			Engine.engine.setGameAttribute("bufferTransfer", "title");
			switchScene(GameModel.get().scenes.get(66).getID(), createFadeOut(0.75, Utils.getColorRGB(255,255,255)), createFadeIn(0.01, Utils.getColorRGB(0,0,0)));
		}, null);

		// Skip the into
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(!isTransitioning()){
				Engine.engine.setGameAttribute("bufferTransfer", "title");
				switchScene(GameModel.get().scenes.get(66).getID(), createFadeOut(0.5, Utils.getColorRGB(255,255,255)), createFadeIn(0.01, Utils.getColorRGB(0,0,0)));
				fadeOutSoundOnChannel(0, 1.5);
				fadeOutSoundOnChannel(1, 1.5);
			}
		});
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN));
		g.alpha = ((textHeight * 20)/100);
		g.drawString(dLine1, (Util.getMidScreenX() - (g.font.font.getTextWidth(dLine1) / Engine.SCALE / 2)), ((getScreenHeight() - 64) + textHeight));
		g.drawString(dLine2, (Util.getMidScreenX() - (g.font.font.getTextWidth(dLine2) / Engine.SCALE / 2)), ((getScreenHeight() - 48) + textHeight));

		g.alpha = 1;
		g.drawString(Util.getString("INTRO_SKIP"), 2, 2);

		if(drawTint){
			g.fillColor = Utils.getColorRGB(153,0,0);
			g.strokeSize = 0;
			g.alpha = (redTintAmount/100);
			Script.setDrawingLayer(0, "2");
			g.fillRect(0, 0, getScreenWidth(), getScreenHeight());
		}
		if(drawBeam){
			g.fillColor = Utils.getColorRGB(0,0,0);
			g.strokeSize = 0;
			g.alpha = 1;
			Script.setDrawingLayer(0, "0");
			g.fillRect((Util.getMidScreenX() - beamWidth), 0, (beamWidth * 2), getActor(1).getYCenter());
			Script.setDrawingLayer(0, "2");
			g.fillRect((Util.getMidScreenX() - beamWidth), getActor(1).getYCenter(), (beamWidth * 2), getScreenHeight());
		}
	}

	public function dialogComplete():Void {
		// Make the letterbox
		bars = new GFX_Letterbox(true);
		// Make the tint tint-ier
		drawTint = true;
		Actuate.tween(this, 3, {redTintAmount:33}).ease(Linear.easeNone);
		// Lazah beam
		runLater(2500, function(timeTask:TimedTask):Void {
			playSoundOnChannel(Assets.get("sfx.intro_beam"), 1);
			drawBeam = true;
			Actuate.tween(this, 5, {beamWidth:16}).ease(Linear.easeNone);
			// Flash the beam a few times
			runLater(6750, function(timeTask:TimedTask):Void {
				drawBeam = false;
				runLater(100, function(timeTask:TimedTask):Void {
					drawBeam = true;
					runLater(100, function(timeTask:TimedTask):Void {
						drawBeam = false;
						playSoundOnChannel(Assets.get("sfx.intro_explosion"), 1);
					}, null);
				}, null);
			}, null);
		}, null);
	}
}