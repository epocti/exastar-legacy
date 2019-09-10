package scripts;

import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
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
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
import nme.ui.Mouse;
import nme.display.Graphics;
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
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;
import scripts.tools.EZImgInstance;
import scripts.tools.Util;

class SE_titleScreen_bg extends SceneScript {
	// Base colors from dark to light: (102), (153), (204)
	var keriiX:Float = -70;
	var keriiY:Float = 210;
	var bg:EZImgInstance;
	var rollers:Array<EZImgInstance> = new Array<EZImgInstance>();
	var ground:Array<EZImgInstance> = new Array<EZImgInstance>();
	var ext1:Array<EZImgInstance> = new Array<EZImgInstance>();
	var ext2:Array<EZImgInstance> = new Array<EZImgInstance>();

	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	//==========================================================

	override public function init(){
		bg = new EZImgInstance("g", false, "title.bgSky");
		bg.attachToWorld("dynamicBg", 0, -bg.getHeight(), 0);
		for(i in 0...2){
			ground.push(new EZImgInstance("g", false, "title.ground1"));
			ground[i].attachToWorld("dynamicBg", 0, 252, 0);
		}
		for(i in 0...3){
			ext2.push(new EZImgInstance("g", false, "title.cloud"));
			ext2[i].attachToWorld("dynamicBg", 0, 0, 0);
		}
		for(i in 0...2){
			ext1.push(new EZImgInstance("g", false, "title.tree"));
			ext1[i].attachToWorld("dynamicBg", 0, 0, 0);
		}
		for(i in 0...2){
			rollers.push(new EZImgInstance("g", false, "title.roller"));
			rollers[i].attachToWorld("dynamicBg", -rollers[0].getWidth(), 231, 0);
		}
		
		// Init positions/color
		rollers[1].setXY(Script.getScreenWidth() + rollers[1].getWidth(), 284);
		ground[1].setXY(Script.getScreenWidth() - 1, 306);
		ground[0].setOrigin("LEFTMID");
		ground[1].setOrigin("RIGHTMID");
		ext1[0].setXY(6, 56);
		ext1[1].setXY(Script.getScreenWidth() - ext1[1].getWidth() - 6, 56);
		ext2[0].setXY(17, -295);
		ext2[1].setXY(216, -267);
		ext2[2].setXY(366, -290);
		for(i in 0...2){
			rollers[i].swapColor(Utils.getColorRGB(102, 102, 102), Utils.getColorRGB(47, 153, 54));
			rollers[i].swapColor(Utils.getColorRGB(153, 153, 153), Utils.getColorRGB(63, 204, 70));
			rollers[i].swapColor(Utils.getColorRGB(204, 204, 204), Utils.getColorRGB(79, 255, 92));
			ground[i].setAlpha(0);
			ground[i].swapColor(Utils.getColorRGB(102, 102, 102), Utils.getColorRGB(47, 153, 54));
			ground[i].swapColor(Utils.getColorRGB(153, 153, 153), Utils.getColorRGB(63, 204, 70));
			ground[i].swapColor(Utils.getColorRGB(204, 204, 204), Utils.getColorRGB(79, 255, 92));
			ext1[i].setOrigin("BOTTOMMID");
			ext1[i].setHeight(0);
		}

		// BG bounce in
		runLater(500, function(timeTask:TimedTask):Void {
			bg.slideTo(0, 0, .5, Quad.easeIn);
			runLater(500, function(timeTask:TimedTask):Void {
				bg.slideTo(0, -48, .33, Quad.easeOut);
				runLater(330, function(timeTask:TimedTask):Void {
					bg.slideTo(0, 0, .33, Quad.easeIn);
					runLater(330, function(timeTask:TimedTask):Void {
						bg.slideTo(0, -24, .25, Quad.easeOut);
						runLater(250, function(timeTask:TimedTask):Void {
							bg.slideTo(0, 0, .25, Quad.easeIn);
						}, null);
					}, null);
				}, null);
			}, null);
		}, null);

		// Rollers in + ground tex stretch
		runLater(250, function(timeTask:TimedTask):Void {
			rollers[0].slideBy(Script.getScreenWidth() + rollers[0].getWidth(), 0, 1, Linear.easeNone);
			rollers[1].slideBy(-(Script.getScreenWidth() + (rollers[1].getWidth() * 2)), 0, 1, Linear.easeNone);
			ground[0].growTo(48000, 100, 1, Linear.easeNone);
			ground[1].growTo(48000, 100, 1, Linear.easeNone);
			ground[0].setAlpha(100);
			ground[1].setAlpha(100);
		}, null);

		// Extra props in
		runLater(750, function(timeTask:TimedTask):Void {
			for(i in 0...2){ ext1[i].growTo(100, 100, 1.25, Elastic.easeOut); }
			runLater(150, function(timeTask:TimedTask):Void {
				ext2[0].slideTo(17, -175, .8, Back.easeOut);
				runLater(150, function(timeTask:TimedTask):Void {
					ext2[1].slideTo(216, -147, .8, Back.easeOut);
					runLater(150, function(timeTask:TimedTask):Void {
						ext2[2].slideTo(366, -170, .8, Back.easeOut);
					}, null);
				}, null);
			}, null);
		}, null);

		// Test actor anims
		runLater(3500, function(timeTask:TimedTask):Void {
			animationAlexBoxes();
			//animationKeriiFly();
			//runLater(11000, function(timeTask:TimedTask):Void { animationRD(); }, null);
		}, null);
	}
	
	public inline function update(elapsedTime:Float){
	}
	
	public inline function draw(g:G){
	}

	function animationKeriiFly():Void {
		var kerii:Actor = createRecycledActorOnLayer(getActorType(640), -70, 210, 1, "characters");
		Script_Emotive.setAnim("kerii", "nFly", "r", false, false);
		Actuate.tween(this, 8.5, {keriiX:520}).ease(Linear.easeNone);
		//kerii.moveBy(520, 0, 8, Linear.easeNone);
		runLater(2200, function(timeTask:TimedTask):Void { Script_Emotive.setAnim("kerii", "happySpin", "d", false, false); }, null);
		runLater(5700, function(timeTask:TimedTask):Void { Script_Emotive.setAnim("kerii", "nFly", "r", false, false); }, null);
		runPeriodically(1, function(timeTask:TimedTask):Void {
			if(kerii.isAlive()){	
				kerii.setX(keriiX);
				kerii.setY(keriiY);
			}
			kerii.setValue("Script_ActorShadow", "height", 290 - keriiY);
		}, null);
		Actuate.tween(this, 1, {keriiY:218}).ease(Quad.easeInOut);
		runLater(1000, function(timeTask:TimedTask):Void { Actuate.tween(this, 1, {keriiY:202}).ease(Quad.easeInOut); }, null);
		runPeriodically(2000, function(timeTask:TimedTask):Void {
			if(kerii.isAlive()){
				Actuate.tween(this, 1, {keriiY:218}).ease(Quad.easeInOut);
				runLater(1000, function(timeTask:TimedTask):Void { Actuate.tween(this, 1, {keriiY:202}).ease(Quad.easeInOut); }, null);
			}
		}, null);
	}

	function animationAlexBoxes():Void {
		Util.disableCameraSnapping();
		Util.disableMovement();
		var alex:Actor = createRecycledActorOnLayer(getActorType(371), -60, 265, 1, "characters");
		Script_Emotive.setAnim("alex", "n", "r", true, false);
		var box1:EZImgInstance = new EZImgInstance("g", false, "env.itemBox.closed");
		var box2:EZImgInstance = new EZImgInstance("g", false, "env.itemBox.closed");
		box1.attachToWorld("characters", 120, 270, 0);
		box1.sendToBack();
		box2.attachToWorld("characters", 310, 270, 0);
		box2.sendToBack();
		alex.moveBy(170, 0, 2, Linear.easeNone);
		runLater(2000, function(timeTask:TimedTask):Void {
			Script_Emotive.setAnim("alex", "n", "u", false, false);
			box1.enableAnimation("env.itemBox.anim", 7, 66, false);
			runLater(500, function(timeTask:TimedTask):Void {
				Script_Emotive.setAnim("alex", "itemGet", "d", false, false);
				runLater(1500, function(timeTask:TimedTask):Void {
					Script_Emotive.setAnim("alex", "n", "r", true, false);
					alex.moveBy(200, 0, 2, Linear.easeNone);
				}, null);
			}, null);
		}, null);
		runLater(6000, function(timeTask:TimedTask):Void {
			Script_Emotive.setAnim("alex", "n", "u", false, false);
			box2.enableAnimation("env.itemBox.anim", 7, 66, false);
			runLater(250, function(timeTask:TimedTask):Void {
				Util.enableInDialog();
				var spikey:Actor = createRecycledActorOnLayer(getActorType(800), 310, 270, 1, "characters");
				// Remove collisions
				var shapeActor:Actor = spikey;
				var fixture:B2Fixture = shapeActor.getBody().getFixtureList();
				while (fixture != null){
					fixture.getBody().DestroyFixture(fixture);
					fixture = fixture.getNext();
				}
				spikey.setValue("Script_NPCEnemy", "disableBounding", true);
			}, null);
			runLater(500, function(timeTask:TimedTask):Void {
				Script_Emotive.setAnim("alex", "spook", "r", false, false);
				createRecycledActorOnLayer(getActorType(452), alex.getX() - 18, alex.getY() - 28, 1, "characters");
				runLater(750, function(timeTask:TimedTask):Void {
					Script_Emotive.setAnim("alex", "n", "l", true, false);
					alex.moveBy(-370, 0, 2.5, Linear.easeNone);
				}, null);
			}, null);
		}, null);
	}

	function animationRD():Void {
		var rod:Actor = createRecycledActorOnLayer(getActorType(731), -60, 265, 1, "characters");
		var dod:Actor = createRecycledActorOnLayer(getActorType(743), -110, 265, 1, "characters");
		Script_Emotive.setAnim("rod", "n", "r", true, false);
		Script_Emotive.setAnim("dod", "n", "r", true, false);
		rod.moveBy(340, 0, 5.7375, Linear.easeNone);
		dod.moveBy(200, 0, 3.375, Linear.easeNone);
		runLater(3375, function(timeTask:TimedTask):Void { Script_Emotive.setAnim("dod", "n", "l", false, false); }, null);
		runLater(5738, function(timeTask:TimedTask):Void {
			Script_Emotive.setAnim("rod", "furious", "l", false, false);
			rod.setX(rod.getX() - 3);
			var rodOrigY = rod.getY();
			runPeriodically(1, function(timeTask:TimedTask):Void {
				if(rod.isAlive()){
					rod.setValue("Script_ActorShadow", "height", rodOrigY - rod.getY());
				}
			}, null);
			rod.moveBy(0, -20, .25, Quad.easeOut);
			runLater(250, function(timeTask:TimedTask):Void { rod.moveBy(0, 20, .25, Quad.easeIn); });
			runLater(750, function(timeTask:TimedTask):Void {
				Script_Emotive.setAnim("dod", "n", "r", false, false);
				createRecycledActorOnLayer(getActorType(452), dod.getX() - 18, dod.getY() - 28, 1, "characters");
				runLater(750, function(timeTask:TimedTask):Void {
					Script_Emotive.setAnim("rod", "n", "r", true, false);
					Script_Emotive.setAnim("dod", "n", "r", true, false);
					rod.moveBy(260, 0, 4, Linear.easeNone);
					dod.moveBy(400, 0, 4, Linear.easeNone);
				});
			}, null);
		}, null);
	}
}