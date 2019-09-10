package scripts;

import scripts.assets.Assets;
import scripts.id.FontID;
import com.stencyl.graphics.G;
import openfl.display.Bitmap;
import scripts.tools.EZImgInstance;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
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
import scripts.tools.Util;
import scripts.gfx.GFX_Letterbox;
import dialog.core.Dialog;

class SE_ow_5_52_cs extends SceneScript {
	public var alexFallen:Bool = false;
	public var alexActor:Actor;
	public var keriiHeight:Float = 0;
	public var alexHeight:Float = 765;
	public var kerriCarry:Bool = false;
	public var keriiShaking:Bool = false;
	public var camX:Int = 520;
	var baseKeriiX:Float = 0;
	var baseKeriiY:Float = 0;
	public var bars:GFX_Letterbox = new GFX_Letterbox(false);

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== Alex sent me r34 of kerii while making this part >:( ====

	override public function init(){
		// Initial
		Util.disableMovement();
		Util.disableCameraSnapping();
		Actuate.tween(this, 14, {camX:0}).ease(Linear.easeNone);
		Script_Emotive.setAnim("kerii", "n", "u", true, false);
		runLater(3000, function(timeTask:TimedTask):Void { getActor(1).moveBy(0, -200, 5, Linear.easeNone); }, null);

		// Relaxing shore sounds ooo
		playSoundOnChannel(Assets.get("mus.shore"), 0);

		// Kerii walks in
		runLater(8000, function(timeTask:TimedTask):Void { dialog.core.Dialog.cbCall("dg_keriilol", "style_main", this, "keriiLookback"); }, null);

		// TODO: Move
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void { getActor(1).setValue("Script_ActorShadow", "height", keriiHeight); });

		// Kerii shaking
		runPeriodically(25, function(timeTask:TimedTask):Void { if(keriiShaking) getActor(1).moveTo(baseKeriiX + randomInt(-1, 1), baseKeriiY + randomInt(-1, 1), .025, Linear.easeNone); }, null);
	}

	public inline function update(elapsedTime:Float){
		engine.moveCamera(camX, 0);
	}

	public inline function draw(g:G){
	}

	// Alex falling into water, location settings, etc.
	public function alexFall():Void {
		Util.disableStatOverlay();
		Script_Emotive.setAnim("kerii", "n", "ur", false, false);
		alexFallen = true;
		playSoundOnChannel(Assets.get("sfx.fall"), 0);
		alexActor = createRecycledActorOnLayer(getActorType(371), 524, -680, 1, "mid");
		alexActor.disableBehavior("Script_CameraFollow");
		runPeriodically(10, function(timeTask:TimedTask):Void {
			alexActor.setValue("Script_ActorShadow", "height", alexHeight);
			if(kerriCarry){
				// the game was crashing here as a result of setXCenter, investigate later
				alexActor.setX(getActor(1).getXCenter() - 24);
				alexActor.setY(getActor(1).getYCenter() + 1);
			}
		}, null);
		alexActor.spinBy(-135, 0.01, Linear.easeNone);
		alexActor.moveTo(30, 112, 4.5, Quad.easeIn);
		Actuate.tween(this, 4.5, {alexHeight:0}).ease(Quad.easeIn);
		Script_Emotive.setAnim("alex", "fall", "r", false, false);
		// in water
		runLater(4500, function(timeTask:TimedTask):Void {
			alexActor.say("Script_ActorShadow", "hide");
			alexActor.disableActorDrawing();
			playSoundOnChannel(Assets.get("sfx.splash"), 6);
			// create water splash
			createRecycledActor(getActorTypeByName("gfx_waterSplash"), 32, 69, Script.FRONT);
			createRecycledActor(getActorType(644), 32, 120, Script.MIDDLE);
			// TODO particle level control
			for(i in 0...16){
				createRecycledActor(getActorTypeByName("prt_waterSplash"), 48, 125, Script.FRONT);
			}
			createRecycledActor(getActorTypeByName("gfx_underwaterObj"), 34, 125, Script.BACK);
		}, null);
	}

	// Kerii doubletake
	public function keriiLookback():Void {
		runLater(2000, function(timeTask:TimedTask):Void {
			playSoundOnChannel(Assets.get("sfx.keriiFlip"), 6);
			Script_Emotive.setAnim("kerii", "n", "d", false, false);
			runLater(2000, function(timeTask:TimedTask):Void {
				Script_Emotive.setAnim("kerii", "n", "ul", false, false);
				playSoundOnChannel(Assets.get("sfx.keriiFlip"), 6);
				runLater(3000, function(timeTask:TimedTask):Void {
					Script_Emotive.setAnim("kerii", "omg", "d", false, false);
					dialog.core.Dialog.cbCall("dg_keriiIntro2", "style_main", this, "keriiPickup");
				}, null);
			}, null);
		}, null);
	}

	// Kerii rescue sequence
	public function keriiPickup():Void {
		Script_Emotive.setAnim("alex", "drowned", "d", false, false);
		// Kerii gets up
		getActor(1).disableActorDrawing();
		getActor(1).say("Script_ActorShadow", "hide");

		createRecycledActor(getActorTypeByName("gfx_keriiRescueSmear"), 23, 78, Script.FRONT);
		// create water splash
		playSoundOnChannel(Assets.get("sfx.splash"), 6);
		createRecycledActor(getActorTypeByName("gfx_waterSplash"), 32, 69, Script.FRONT);
		createRecycledActor(getActorType(644), 32, 120, Script.MIDDLE);
		// TODO particle level control
		for(i in 0...16){
			createRecycledActor(getActorTypeByName("prt_waterSplash"), 48, 125, Script.FRONT);
		}
		
		runLater(1250, function(timeTask:TimedTask):Void {
			// Kerii goes down to the water
			getActor(1).setX(42);
			getActor(1).setY(118);
			runLater(1000, function(timeTask:TimedTask):Void {
				// Kerii flies up with alex
				kerriCarry = true;
				alexActor.spinTo(0, 0.01, Linear.easeNone);
				alexActor.enableActorDrawing();
				alexActor.say("Script_ActorShadow", "show");
				Actuate.tween(this, 1.5, {keriiHeight:25}).ease(Expo.easeOut);
				Actuate.tween(this, 1.5, {alexHeight:22}).ease(Expo.easeOut);
				getActor(1).moveBy(0, -25, 1.5, Expo.easeOut);
				Script_Emotive.setAnim("kerii", "carryAlt", "d", false, false);
				getActor(1).enableActorDrawing();
				getActor(1).say("Script_ActorShadow", "show");
				playSoundOnChannel(Assets.get("sfx.splash2"), 6);
				createRecycledActor(getActorType(644), 32, 120, Script.BACK);
				// TODO particle level control
				for(i in 0...16){
					createRecycledActor(getActorTypeByName("prt_waterSplashM"), 48, 125, Script.MIDDLE);
				}
				// Kill underwater effect
				for(actorOfType in getActorsOfType(getActorTypeByName("gfx_underwaterObj"))){
					if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
						recycleActor(actorOfType);
					}
				}
				runLater(2000, function(timeTask:TimedTask):Void {
					loopSoundOnChannel(Assets.get("sfx.keriiCarry"), 6);
					getActor(1).moveTo(180, 160, 4, Linear.easeNone);
					runLater(2000, function(timeTask:TimedTask):Void {
						Script_Emotive.setAnim("kerii", "carryAlt2", "d", false, false);
						createRecycledActor(getActorTypeByName("prt_bodySweatR"), getActor(1).getX() + 23, getActor(1).getY() - 2, Script.FRONT);
						runLater(300, function(timeTask:TimedTask):Void { createRecycledActor(getActorTypeByName("prt_bodySweatL"), getActor(1).getX() - 8, getActor(1).getY() - 2, Script.FRONT); }, null);
						runPeriodically(600, function(timeTask:TimedTask):Void {
							if(kerriCarry){
								createRecycledActor(getActorTypeByName("prt_bodySweatR"), getActor(1).getX() + 23, getActor(1).getY() - 2, Script.FRONT);
								runLater(300, function(timeTask:TimedTask):Void { createRecycledActor(getActorTypeByName("prt_bodySweatL"), getActor(1).getX() - 8, getActor(1).getY() - 2, Script.FRONT); }, null);
							}
						}, null);
					}, null);
					runLater(4000, function(timeTask:TimedTask):Void { stopSoundOnChannel(6); }, null);
					runLater(4500, function(timeTask:TimedTask):Void {
						playSoundOnChannel(Assets.get("sfx.keriiLetGo"), 6);
						Script_Emotive.setAnim("kerii", "letGoAlt", "d", false, false);
						runLater(100, function(timeTask:TimedTask):Void {
							createRecycledActor(getActorTypeByName("prt_smallCloudR"), getActor(1).getX() + 20, getActor(1).getY() + 8, Script.MIDDLE);
							kerriCarry = false;
							alexActor.moveBy(0, 18, .125, Quad.easeIn);
							Actuate.tween(this, .125, {alexHeight:0}).ease(Quad.easeIn);
							runLater(125, function(timeTask:TimedTask):Void { Script_Emotive.setAnim("alex", "drowned2", "d", false, false); }, null);
							runLater(1500, function(timeTask:TimedTask):Void {
								Script_Emotive.setAnim("kerii", "nAlt", "d", true, false);
								getActor(1).moveBy(0, -24, .25, Quad.easeOut);
								runLater(250, function(timeTask:TimedTask):Void {
									getActor(1).moveBy(0, 20, .25, Quad.easeOut);
									Actuate.tween(this, .25, {keriiHeight:0}).ease(Linear.easeNone);
									runLater(250, function(timeTask:TimedTask):Void {
										// dialog
										Script_Emotive.setAnim("kerii", "omg2", "d", false, false);
										Dialog.cbCall("dg_keriiIntro3", "style_main", this, "alexWalkAway");
										// kerii shaking
										baseKeriiX = getActor(1).getX(true);
										baseKeriiY = getActor(1).getY(true);
										keriiShaking = true;
									}, null);
								}, null);
							}, null);
						}, null);
					}, null);
				}, null);
			}, null);
		}, null);
	}

	function alexWalkAway():Void {
		Script_Emotive.setAnim("alex", "fakeWorry", "d", true, false);
		Script_Emotive.setAnim("kerii", "wtf", "d", false, false);
		alexActor.moveBy(0, 33, 1.5, Linear.easeNone);
		runLater(1500, function(timeTask:TimedTask):Void {
			createRecycledActor(getActorTypeByName("gfx_keriiBlockSmear"), 183, 161, Script.FRONT);
			runLater(100, function(timeTask:TimedTask):Void {
				Script_Emotive.setAnim("alex", "ohPause", "d", false, false);
				alexActor.moveBy(0, -38, .2, Quad.easeOut);
				Script_Emotive.setAnim("kerii", "n", "u", false, false);
				getActor(1).setX(179);
				getActor(1).setY(221);
				runLater(1000, function(timeTask:TimedTask):Void {
					// dialog
					Dialog.cbCall("dg_keriiIntro4", "style_main", this, null);
				}, null);
			}, null);
		}, null);
	}

	public function stopKeriiShaking():Void { keriiShaking = false; }
	public function cueMusic():Void { loopSoundOnChannel(Assets.get("mus.keriiIntro"), 0); }

	public function spamDialogSnd():Void {
		var doIt:Bool = true;
		setVolumeForChannel(.5, 6);
		runPeriodically(40, function(timeTask:TimedTask):Void {
			if(doIt) playSoundOnChannel(getSoundByName("sfx_dialog_" + randomInt(1,4)), 6);
		}, null);
		runLater(4000, function(timeTask:TimedTask):Void {
			doIt = false;
		}, null);
	}
	
	public function end():Void {
		Script_Emotive.setAnim("kerii", "n", "d", false, false);
		Script_Emotive.setAnim("alex", "n", "r", false, false);
		setValueForScene("Script_Mapper", "player", alexActor);
		Util.enableCameraSnapping();
		bars.hide();
	}
}