package scripts;

import com.stencyl.models.GameModel;
import scripts.gfx.GFX_Letterbox;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.utils.Utils;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.Engine;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;

class SE_c0_expositionEndIntro extends SceneScript {
	var lbox:GFX_Letterbox = new GFX_Letterbox(false);

    public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ========
	
	override public function init(){
		Script_Emotive.setAnim("alex", "upfall", "d", false, false);
		Util.disableMovement();
		Util.disableStatOverlay();
		getActor(1).growTo(.01, .01, .01);
		getActor(1).spinBy(15, .01);
		runLater(10, function(timeTask:TimedTask):Void {
			getActor(1).growTo(48, 48, 1.5, Expo.easeIn);
			getActor(1).spinBy(20, 1.5, Linear.easeNone);
			getActor(1).moveBy(-100, 50, 1.5, Linear.easeNone);
		}, null);
		runLater(1180, function(timeTask:TimedTask):Void {
			getActor(1).fadeTo(0, .33, Linear.easeNone);
		}, null);
		runLater(1510, function(timeTask:TimedTask):Void {
			removeBackground(0, "1");
			addBackground("bg_eeClouds0", "bg_eeClouds0", 0);
			Script_Emotive.setAnim("alex", "upfall", "u", false, false);
			getActor(1).fadeTo(1, .33, Linear.easeNone);
			getActor(1).spinTo(15, .01);
			getActor(1).growTo(.25, .25, 4, Expo.easeOut);
			getActor(1).moveBy(0, -100, 2, Quad.easeOut);
			runLater(2000, function(timeTask:TimedTask):Void {
				getActor(1).moveBy(0, 100, 2, Quad.easeIn);
			}, null);
			runLater(3000, function(timeTask:TimedTask):Void {
				switchScene(GameModel.get().scenes.get(82).getID(), createFadeOut(1, Utils.getColorRGB(255,255,255)), createFadeIn(1, Utils.getColorRGB(255,255,255)));
			}, null);
		}, null);
	}
	
	public inline function update(elapsedTime:Float){
	}
	
	public inline function draw(g:G){
	}
}
