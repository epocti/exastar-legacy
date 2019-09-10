package scripts;

import scripts.id.FontID;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.Actuate;
import motion.easing.Linear;
import scripts.tools.Util;
import scripts.assets.Assets;
import scripts.tools.EZImgInstance;
import scripts.Script_Emotive;

class SE_buffer extends SceneScript {
	var opacity:Int = 0;
	var chapterSepWidth:Int = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== Allie keeps texting me bad memes, someone tell her to stop ====

	override public function init(){
		// Title
		if(Util.getAttr("bufferTransfer") == "title"){
			setColorBackground(Utils.getColorRGB(255,255,255));
			runLater(3000, function(timeTask:TimedTask):Void {
				switchScene(GameModel.get().scenes.get(4).getID(), createFadeOut(0.01, Utils.getColorRGB(255,255,255)), createFadeIn(.5, Utils.getColorRGB(240,240,240)));
			}, null);
		}
		// exposition ending
		else if(Util.getAttr("bufferTransfer") == "c0_expositionEnd"){
			setColorBackground(Utils.getColorRGB(255,255,255));
			runLater(2000, function(timeTask:TimedTask):Void {
				Actuate.tween(this, .5, {opacity:100}).ease(Linear.easeNone);
				runLater(6000, function(timeTask:TimedTask):Void {
					Actuate.tween(this, .5, {opacity:0}).ease(Linear.easeNone);
					runLater(5000, function(timeTask:TimedTask):Void {
						switchScene(GameModel.get().scenes.get(83).getID(), createFadeOut(.01, Utils.getColorRGB(255,255,255)), createFadeIn(5, Utils.getColorRGB(255,255,255)));
					}, null);
				}, null);
			}, null);
		}
		// file creation
		else if(Util.getAttr("bufferTransfer") == "fc"){
			runLater(2500, function(timeTask:TimedTask):Void {
				switchScene(GameModel.get().scenes.get(60).getID(), null, createCrossfadeTransition(1));
			}, null);
		}
		// alien prologue
		else if(Util.getAttr("bufferTransfer") == "prologue"){
			runLater(5000, function(timeTask:TimedTask):Void { Util.switchSceneImmediate("c0_alien_sv_intro"); }, null);
		}
		// tbc part 2
		else if(Util.getAttr("bufferTransfer") == "tbc_kokoScn"){
			runLater(2000, function(timeTask:TimedTask):Void { Util.switchSceneImmediate("tbc_kokoScn"); }, null);
		}
		// load from savegame
		else if(Util.getAttr("bufferTransfer") == "savegame"){
			// Reset some variables to get ready for the next scene
			Util.setAttr("inDialog", false);
			Util.movement = true;
			Util.snapCamera = true;

			Script_Emotive.resetAll();
			
			loopSoundOnChannel(Assets.get("mus.fdrive"), 0);
			var silhouette:EZImgInstance = new EZImgInstance("g", true, "engine.load.silhouetteRun1");
			silhouette.enableAnimation("engine/load/silhouetteRun", 2, 200, true);
			silhouette.setXY(23 + getFont(FontID.MAIN_WHITE).font.getTextWidth("Loading...") + 4, getScreenHeight() - silhouette.getHeight() - 2);
			runLater(2000, function(timeTask:TimedTask):Void { atlasLoadingComplete(); }, null);
		}
	}

	public inline function draw(g:G){
		if(Util.getAttr("bufferTransfer") == "c0_expositionEnd"){
			g.alpha = (opacity/100);
			g.setFont(getFont(FontID.MAIN));
			g.drawString(Util.getString("EXPOSITIONEND_BEGIN"), (Util.getMidScreenX() - (g.font.font.getTextWidth("And thus, the journey began...")/Engine.SCALE / 2)), (Util.getMidScreenY() - (g.font.getHeight()/Engine.SCALE / 2)));
		}
		else if(Util.getAttr("bufferTransfer") == "savegame"){
			g.alpha = 1;
			g.strokeSize = 0;
			g.fillColor = Utils.getColorRGB(35, 35, 35);
			g.fillCircle(10, getScreenHeight() - 10, 8);
			g.fillColor = Utils.getColorRGB(255, 255, 255);
			g.setFont(getFont(FontID.MAIN_WHITE));
			g.drawString("Loading...", 23, getScreenHeight() - 18);
			DrawCircles.drawWedge(g, true, true, 10, getScreenHeight() - 10, /*animCounter*/-90, /*animCounter*/-90 + ((Assets.getLoaded() / Assets.getTotal()) * 360), 8);
		}
	}

	function atlasLoadingComplete():Void {
		fadeOutSoundOnChannel(0, .45);
		runLater(450, function(timeTask:TimedTask):Void { stopSoundOnChannel(0); }, null);
		runLater(500, function(timeTask:TimedTask):Void { Util.switchSceneImmediate(Util.getAttr("savedLocation")); }, null);
	}
}
