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

class SE_ow_12_153 extends SceneScript {
	public var alexFallen:Bool = false;
	public var alexActor:Actor;
	public var keriiHeight:Float = 0;
	public var alexHeight:Float = 765;
	public var kerriCarry:Bool = false;
	public var keriiShaking:Bool = false;
	public var camX:Int = 520;
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
		runLater(8000, function(timeTask:TimedTask):Void { dialog.core.Dialog.cbCall("dg_keriiIntro1", "style_main", this, "keriiLookback"); }, null);

		// TODO: Move
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void { getActor(1).setValue("Script_ActorShadow", "height", keriiHeight); });
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
		alexActor = createRecycledActor(getActorType(371), 524, -680, Script.MIDDLE);
		alexActor.disableBehavior("Script_CameraFollow");
		runPeriodically(10, function(timeTask:TimedTask):Void {
			alexActor.setValue("Script_ActorShadow", "height", alexHeight);
			if(kerriCarry){
				// the game was crashing here as a result of setXCenter, investigate later
				alexActor.setX(getActor(1).getXCenter() - 24);
				alexActor.setY(getActor(1).getYCenter());
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
			playSoundOnChannel(Assets.get("sfx.splash"), 0);
			createRecycledActor(getActorType(646), 32, 69, Script.FRONT);
			createRecycledActor(getActorType(644), 24, 120, Script.MIDDLE);
		}, null);
	}

	// Kerii doubletake
	public function keriiLookback():Void {
		runLater(2000, function(timeTask:TimedTask):Void {
			Script_Emotive.setAnim("kerii", "n", "ul", false, false);
			runLater(3000, function(timeTask:TimedTask):Void {
				Script_Emotive.setAnim("kerii", "omg", "d", false, false);
				startShakingScreen(.01, .25);
				dialog.core.Dialog.cbCall("dg_keriiIntro2", "style_main", this, "keriiPickup");
			}, null);
		}, null);
	}

	// Kerii rescue sequence
	public function keriiPickup():Void {
		Script_Emotive.setAnim("alex", "drowned", "d", false, false);
		// Kerii gets up
		Actuate.tween(this, .5, {keriiHeight:20}).ease(Quad.easeOut);
		getActor(1).moveBy(0, -20, .5, Quad.easeOut);
		Script_Emotive.setAnim("kerii", "nAlt", "u", false, false);
		runLater(750, function(timeTask:TimedTask):Void {
			// Kerii flies to where alex fell
			getActor(1).moveTo(alexActor.getXCenter(), (alexActor.getYCenter() - 30), .5, Linear.easeNone);
			runLater(500, function(timeTask:TimedTask):Void {
				// Kerii goes down to the water
				Actuate.tween(this, .75, {keriiHeight:0}).ease(Quad.easeOut);
				getActor(1).moveBy(0, 20, .75, Quad.easeOut);
				Script_Emotive.setAnim("kerii", "n", "u", false, false);
				runLater(1000, function(timeTask:TimedTask):Void {
					// Kerii flies up with alex
					kerriCarry = true;
					alexActor.spinTo(0, 0.01, Linear.easeNone);
					alexActor.enableActorDrawing();
					// TODO: the game crashes here, cool
					alexActor.say("Script_ActorShadow", "show");
					Actuate.tween(this, 2, {keriiHeight:20}).ease(Linear.easeNone);
					Actuate.tween(this, 2, {alexHeight:18}).ease(Linear.easeNone);
					getActor(1).moveBy(0, -20, 2, Linear.easeNone);
					Script_Emotive.setAnim("kerii", "carryAlt", "d", false, false);
					runLater(2000, function(timeTask:TimedTask):Void {
						getActor(1).moveTo(180, 160, 4, Linear.easeNone);
						runLater(4500, function(timeTask:TimedTask):Void {
							Script_Emotive.setAnim("kerii", "letGoAlt", "d", false, false);
							kerriCarry = false;
							alexActor.moveBy(0, 18, .125, Linear.easeNone);
							Actuate.tween(this, .125, {alexHeight:0}).ease(Linear.easeNone);
							runLater(1500, function(timeTask:TimedTask):Void {
								Script_Emotive.setAnim("kerii", "nAlt", "d", true, false);
								getActor(1).moveBy(0, -24, .25, Quad.easeOut);
								runLater(250, function(timeTask:TimedTask):Void {
									getActor(1).moveBy(0, 20, .25, Quad.easeOut);
									Actuate.tween(this, .25, {keriiHeight:0}).ease(Linear.easeNone);
									runLater(250, function(timeTask:TimedTask):Void {
										// dialog
										Script_Emotive.setAnim("kerii", "omg2", "d", false, false);
										dialog.core.Dialog.cbCall("dg_keriiIntro3", "style_main", this, "");
										// kerii shaking
										var baseKeriiX:Float = getActor(1).getX(true);
										var baseKeriiY:Float = getActor(1).getY(true);
										keriiShaking = true;
										runPeriodically(25, function(timeTask:TimedTask):Void { if(keriiShaking) getActor(1).moveTo(baseKeriiX + randomInt(-1, 1), baseKeriiY + randomInt(-1, 1), .025, Linear.easeNone); }, null);
									}, null);
								}, null);
							}, null);
						}, null);
					}, null);
				}, null);
			}, null);
		}, null);
	}

	public function stopKeriiShaking():Void { keriiShaking = false; }
	public function cueMusic():Void { loopSoundOnChannel(Assets.get("mus.keriiIntro"), 0); }
}