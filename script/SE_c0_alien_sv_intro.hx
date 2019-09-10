package scripts;

import scripts.assets.Assets;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.Actuate;
import motion.easing.Expo;
import motion.easing.Linear;
import com.stencyl.graphics.shaders.TintShader;
import scripts.Script_Emotive;
import scripts.tools.Util;

class SE_c0_alien_sv_intro extends SceneScript {
	public var starX:Float = 0;
	public var starY:Float = 0;
	public var drawStep:Float = 0;
	public var tintAmount:Float = 0;
	public var tintShader:Dynamic;
	public var lineW1:Float = 0;
	public var lineW2:Float = 0;
	public var lineW3:Float = 0;
	public var lineW4:Float = 0;
	public var ch:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	public var str1:String = "";
	public var str2:String = "";
	public var str3:String = "";
	public var str4:String = "";

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== the drawing doesn't work and it doesn't make sense ====
	// FIXME: No clue what is happening here, but the draw function is NOT working AT ALL - maybe reimport the code? edit: now it works
	// FIXME: now nothing is working lol

	override public function init(){
		getActor(4).disableBehavior("Script_BoundToScene");
		Util.disableCameraSnapping();
		Script_Emotive.setAnim("chief", "coffee", "l", false, false);

		// Create selector
		runLater(2500, function(timeTask:TimedTask):Void {
			createRecycledActor(getActorType(387), getScreenWidth(), getScreenHeight(), Script.MIDDLE);
			runLater(3500, function(timeTask:TimedTask):Void { createRecycledActor(getActorType(389), starX, starY, Script.FRONT); }, null);
		}, null);

		// Fade out selector
		runLater(10000, function(timeTask:TimedTask):Void {
			for(actorOfType in getActorsOfType(getActorType(389))){
				if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
					actorOfType.growTo(4, 4, .25, Expo.easeOut);
					actorOfType.fadeTo(0, .25, Expo.easeOut);
					runLater(250, function(timeTask:TimedTask):Void {
						recycleActor(actorOfType);
					}, null);
				}
			}
			// Shrink scene background
			getActor(2).growTo(1, 1, 2.5, Expo.easeOut);
			getActor(2).moveTo(0, 0, 2.5, Expo.easeOut);
			// Shrink stars background
			getActor(1).growTo(.95, .95, 2.5, Expo.easeOut);
			runLater(4000, function(timeTask:TimedTask):Void { createRecycledActor(getActorType(393), 168, 77, Script.MIDDLE); }, null);
			runLater(5500, function(timeTask:TimedTask):Void {
				runPeriodically(500, function(timeTask:TimedTask):Void {
					drawStep += 1;
				}, null);
				Actuate.tween(this, 1, {lineW1:50}).ease(Expo.easeOut);
				runLater(250, function(timeTask:TimedTask):Void {
					Actuate.tween(this, 1, {lineW2:50}).ease(Expo.easeOut);
					runLater(250, function(timeTask:TimedTask):Void {
						Actuate.tween(this, 1, {lineW3:50}).ease(Expo.easeOut);
						runLater(250, function(timeTask:TimedTask):Void { Actuate.tween(this, 1, {lineW4:50}).ease(Expo.easeOut); }, null);
					}, null);
				}, null);
			}, null);
			runLater(14500, function(timeTask:TimedTask):Void { createRecycledActor(getActorType(396), 171, 80, Script.FRONT); }, null);
			runLater(18500, function(timeTask:TimedTask):Void {
				tintShader = new TintShader(Utils.getColorRGB(255,0,0), 0);
				tintShader.enable();
				startShakingScreen(.03, .2);
				for(actorOfType in getActorsOfType(getActorType(396))){
					if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
						runPeriodically(50, function(timeTask:TimedTask):Void { actorOfType.moveTo((170 + randomInt(Math.floor(-3), Math.floor(3))), (79 + randomInt(Math.floor(-3), Math.floor(3))), 0.05, Linear.easeNone); }, null);
						actorOfType.setAnimation("2");
					}
				}
				tintShader.tweenProperty("amount", .33, 1, Linear.easeNone);
				runLater(1000, function(timeTask:TimedTask):Void { tintShader.tweenProperty("amount", 0, 1, Linear.easeNone); }, null);
				runPeriodically(2000, function(timeTask:TimedTask):Void {
					tintShader.tweenProperty("amount", .33, 1, Linear.easeNone);
					runLater(1000, function(timeTask:TimedTask):Void { tintShader.tweenProperty("amount", 0, 1, Linear.easeNone); }, null);
				}, null);
			}, null);
			runLater(20000, function(timeTask:TimedTask):Void {
				loopSoundOnChannel(Assets.get("mus.alien"), 0);
				setVolumeForChannel(0, 1);
				loopSoundOnChannel(Assets.get("mus.alienOutside"), 1);
				getActor(4).moveTo(Util.getMidScreenX() - (getActor(4).getWidth()/2), getActor(4).getY(), 4, Linear.easeNone);
				dialog.core.Dialog.cbCall("cscene_alien_alert1", "style_main", this, "p2");
			}, null);
		}, null);
	}

	public inline function update(elapsedTime:Float){
		for(actorOfType in getActorsOfType(getActorType(389))){
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				actorOfType.setX(starX - 12);
				actorOfType.setY(starY - 12);
			}
		}
		for(actorOfType in getActorsOfType(getActorType(387))){
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				starX = actorOfType.getXCenter();
				starY = actorOfType.getYCenter();
			}
		}
		// Random string creation
		str1 = "";
		str2 = "";
		str3 = "";
		str4 = "";
		for(i in 0...12){
			str1 = (str1 + ch.charAt(randomInt(Math.floor(1), Math.floor(62))));
			str2 = (str2 + ch.charAt(randomInt(Math.floor(1), Math.floor(62))));
			str3 = (str3 + ch.charAt(randomInt(Math.floor(1), Math.floor(62))));
			str4 = (str4 + ch.charAt(randomInt(Math.floor(1), Math.floor(62))));
		}
	}

	public inline function draw(g:G){
		g.alpha = 1;
		g.fillColor = Utils.getColorRGB(0,255,0);
		g.strokeColor = Utils.getColorRGB(0,255,0);
		g.strokeSize = 1;
		g.setFont(getFont(623));
		if(drawStep <= 17){
			g.drawLine(205, 117, (205 + lineW1), 117);
			g.drawLine(205, 132, (205 + lineW2), 132);
			g.drawLine(205, 143, (205 + lineW3), 143);
			g.drawLine(205, 152, (205 + lineW4), 152);
			if(drawStep >= 7) g.drawString(str1, 258, 115);
			if(drawStep >= 9) g.drawString(str2, 258, 130);
			if(drawStep >= 11) g.drawString(str3, 258, 141);
			if(drawStep >= 13) g.drawString(str4, 258, 150);
		}
	}

	public function p2():Void {
		runLater(1000, function(timeTask:TimedTask):Void { Script_Emotive.setAnim("chief", "n", "u", false, false); }, null);
		runLater(4000, function(timeTask:TimedTask):Void {
			createRecycledActor(getActorType(415), 240, 240, Script.FRONT);
			startShakingScreen(.03, .2);
			Script_Emotive.setAnim("chief", "shockAgape", "l", false, false);
			dialog.core.Dialog.cbCall("cscene_alien_alert2", "style_main", this, "p3");
		}, null);
	}

	public function p3():Void {
		engine.clearShaders();
		runLater(1000, function(timeTask:TimedTask):Void {
			Script_Emotive.setAnim("chief", "n", "u", false, false);
			dialog.core.Dialog.cbCall("cscene_alien_alert3", "style_main", this, "p4");
		}, null);
	}

	public function p4():Void {
		runLater(3000, function(timeTask:TimedTask):Void {
			startShakingScreen(.03, .2);
			Script_Emotive.setAnim("chief", "shockAgape", "l", false, false);
			dialog.core.Dialog.cbCall("cscene_alien_alert4", "style_main", this, "p5");
		}, null);
	}

	public function p5():Void { switchScene(GameModel.get().scenes.get(70).getID(), createFadeOut(.75, Utils.getColorRGB(0,0,0)), createFadeIn(.75, Utils.getColorRGB(0,0,0))); }
}