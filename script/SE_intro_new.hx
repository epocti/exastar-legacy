/*
	This script (C) 2018 Epocti.
	Description: New intro scene events
	Author: kokoscript
*/

package scripts;

// Stencyl Engine
import openfl.events.KeyboardEvent;
import scripts.tools.Util;
import scripts.id.FontID;
import scripts.assets.Assets;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
// Stencyl Datatypes
import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;
// Tweens
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

class SE_intro_new extends SceneScript {
	var dialogList:Array<String> = new Array<String>();
	var dialogLine:Int = 0;
	var textHeight:Float = 0.0;
	var currentDialogWords:Array<Dynamic>;
	var dLine1:String = "";
	var dLine2:String = "";

	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		playSoundOnChannel(Assets.get("mus.intro3tmp"), 0);

		// Set up dialog
		for(i in 1...14){ dialogList.push(Util.getString("NEWINTRO_" + i)); }
		dialogList.push("");

		Engine.engine.setGameAttribute("bufferTransfer", "title");

		// Dialog loop
		runLater(3000, function(timeTask:TimedTask):Void {
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
			runLater(5600, function(timeTask:TimedTask):Void { Actuate.tween(this, .5, {textHeight:0}).ease(Linear.easeNone); }, null);

			// Change dialog text and reformat
			runPeriodically(6100, function(timeTask:TimedTask):Void {
				if(dialogLine < 14){
					Actuate.tween(this, .5, {textHeight:5}).ease(Linear.easeNone);
					runLater(5600, function(timeTask:TimedTask):Void { Actuate.tween(this, .5, {textHeight:0}).ease(Linear.easeNone); }, null);
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
		}, null);

		runLater(83000, function(timeTask:TimedTask):Void { endIntro(false); }, null);

		// Skip the into
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			endIntro(true);
		});
	}

	public inline function update(elapsedTime:Float){
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN));
		g.alpha = ((textHeight * 20)/100);
		g.drawString(dLine1, (Util.getMidScreenX() - (g.font.font.getTextWidth(dLine1) / Engine.SCALE / 2)), ((getScreenHeight() - 64) + textHeight));
		g.drawString(dLine2, (Util.getMidScreenX() - (g.font.font.getTextWidth(dLine2) / Engine.SCALE / 2)), ((getScreenHeight() - 48) + textHeight));

		g.alpha = 1;
		g.drawString(Util.getString("INTRO_SKIP"), 2, 2);
	}

	function endIntro(withFade:Bool){
		if(!isTransitioning()){
			Engine.engine.setGameAttribute("bufferTransfer", "title");
			switchScene(GameModel.get().scenes.get(66).getID(), createFadeOut(0.5, Utils.getColorRGB(255,255,255)), createFadeIn(0.01, Utils.getColorRGB(0,0,0)));
			if(withFade){
				fadeOutSoundOnChannel(0, 1.5);
				fadeOutSoundOnChannel(1, 1.5);
			}
		}
	}
}
