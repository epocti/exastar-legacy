package scripts;

import scripts.saves.SaveManager;
import scripts.id.FontID;
import scripts.tools.Util;
import scripts.tools.EZImgInstance;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.models.Region;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.easing.Quad;

class SE_exastart extends SceneScript {
	var imgArray:Array<EZImgInstance> = new Array<EZImgInstance>();

	var regFS:Region = createBoxRegion(24, 36, 204, 36);
	var regEffects:Region = createBoxRegion(24, 84, 204, 36);
	var regShaders:Region = createBoxRegion(24, 132, 204, 36);
	var regCompat:Region = createBoxRegion(24, 180, 204, 36);
	var regFramerate:Region = createBoxRegion(24, 228, 204, 36);
	var regMus:Region = createBoxRegion(252, 36, 204, 36);
	var regSfx:Region = createBoxRegion(252, 84, 204, 36);
	var regKeymap:Region = createBoxRegion(252, 144, 204, 36);
	var regExit:Region = createBoxRegion(getScreenWidth() - 128, getScreenHeight() - 24, 128, 24);

    public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ========
	
	override public function init(){
		// Init images
		imgArray.push(new EZImgInstance("g", false, "settingsButton.fsos_t"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.fx_t"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.sh_t"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.compat_t"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.fr_60"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.mus_t"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.sfx_t"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.keymap"));
		imgArray.push(new EZImgInstance("g", false, "settingsButton.exitButton"));
		// Initial screen attachments
		imgArray[0].attachToScreen(24, 36);
		imgArray[1].attachToScreen(24, 84);
		imgArray[2].attachToScreen(24, 132);
		imgArray[3].attachToScreen(24, 180);
		imgArray[4].attachToScreen(24, 228);
		imgArray[5].attachToScreen(252, 36);
		imgArray[6].attachToScreen(252, 84);
		imgArray[7].attachToScreen(252, 144);
		imgArray[8].attachToScreen(getScreenWidth() - 128, getScreenHeight() - 24);
		// Origin setting
		for(img in imgArray){ img.setOrigin("CENTER"); }
		imgArray[8].setOrigin("BOTTOMRIGHT");

		// Button click listeners

		// fs
		addMouseOverActorListener(regFS, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				if(Util.getAttr("kitsuneConfig").get("fsOnStart") == "true") Util.getAttr("kitsuneConfig").set("fsOnStart", "false");
				else Util.getAttr("kitsuneConfig").set("fsOnStart", "true");

				imgArray[0].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { imgArray[0].growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});
		// fx
		addMouseOverActorListener(regEffects, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				if(Util.getAttr("kitsuneConfig").get("effectLevel") == "2") Util.getAttr("kitsuneConfig").set("effectLevel", "1");
				else if (Util.getAttr("kitsuneConfig").get("effectLevel") == "1") Util.getAttr("kitsuneConfig").set("effectLevel", "0");
				else Util.getAttr("kitsuneConfig").set("effectLevel", "2");

				imgArray[1].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { imgArray[1].growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});
		// shaders
		addMouseOverActorListener(regShaders, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				if(Util.getAttr("kitsuneConfig").get("shaderLevel") == "2") Util.getAttr("kitsuneConfig").set("shaderLevel", "1");
				else if (Util.getAttr("kitsuneConfig").get("shaderLevel") == "1") Util.getAttr("kitsuneConfig").set("shaderLevel", "0");
				else Util.getAttr("kitsuneConfig").set("shaderLevel", "2");

				imgArray[2].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { imgArray[2].growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});
		// compat mode
		addMouseOverActorListener(regCompat, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				if(Util.getAttr("kitsuneConfig").get("compat") == "true") Util.getAttr("kitsuneConfig").set("compat", "false");
				else Util.getAttr("kitsuneConfig").set("compat", "true");

				imgArray[3].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { imgArray[3].growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});
		// framerate
		addMouseOverActorListener(regFramerate, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				if(Util.getAttr("kitsuneConfig").get("frameCount") == "60") Util.getAttr("kitsuneConfig").set("frameCount", "30");
				else if (Util.getAttr("kitsuneConfig").get("frameCount") == "30") Util.getAttr("kitsuneConfig").set("frameCount", "24");
				else Util.getAttr("kitsuneConfig").set("frameCount", "60");

				imgArray[4].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { imgArray[4].growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});
		// music
		addMouseOverActorListener(regMus, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				if(Util.getAttr("kitsuneConfig").get("music") == "true") Util.getAttr("kitsuneConfig").set("music", "false");
				else Util.getAttr("kitsuneConfig").set("music", "true");

				imgArray[5].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { imgArray[5].growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});
		// sfx
		addMouseOverActorListener(regSfx, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				if(Util.getAttr("kitsuneConfig").get("sfx") == "true") Util.getAttr("kitsuneConfig").set("sfx", "false");
				else Util.getAttr("kitsuneConfig").set("sfx", "true");

				imgArray[6].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { imgArray[6].growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});
		// keymap
		addMouseOverActorListener(regKeymap, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				imgArray[7].growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { switchScene(GameModel.get().scenes.get(87).getID(), null, createCrossfadeTransition(.25)); }, null);
			}
		});
		// exit
		addMouseOverActorListener(regExit, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3){
				imgArray[8].growTo(85, 85, .08, Quad.easeInOut);
				SaveManager.SaveConfig();
				runLater(80, function (timeTask:TimedTask):Void { switchScene(GameModel.get().scenes.get(9).getID(), createFadeOut(0.001, Utils.getColorRGB(0,0,0)), createFadeIn(0.01, Utils.getColorRGB(0,0,0))); }, null);
			}
		});
	}
	
	public inline function update(elapsedTime:Float){
		// Image update
		if(Util.getAttr("kitsuneConfig").get("fsOnStart") == "true") imgArray[0].changeImage("settingsButton.fsos_t");
		if(Util.getAttr("kitsuneConfig").get("fsOnStart") == "false") imgArray[0].changeImage("settingsButton.fsos_f");

		if(Util.getAttr("kitsuneConfig").get("effectLevel") == "2") imgArray[1].changeImage("settingsButton.fx_t");
		if(Util.getAttr("kitsuneConfig").get("effectLevel") == "1") imgArray[1].changeImage("settingsButton.fx_m");
		if(Util.getAttr("kitsuneConfig").get("effectLevel") == "0") imgArray[1].changeImage("settingsButton.fx_f");

		if(Util.getAttr("kitsuneConfig").get("shaderLevel") == "2") imgArray[2].changeImage("settingsButton.sh_t");
		if(Util.getAttr("kitsuneConfig").get("shaderLevel") == "1") imgArray[2].changeImage("settingsButton.sh_m");
		if(Util.getAttr("kitsuneConfig").get("shaderLevel") == "0") imgArray[2].changeImage("settingsButton.sh_f");

		if(Util.getAttr("kitsuneConfig").get("compat") == "true") imgArray[3].changeImage("settingsButton.compat_t");
		if(Util.getAttr("kitsuneConfig").get("compat") == "false") imgArray[3].changeImage("settingsButton.compat_f");

		if(Util.getAttr("kitsuneConfig").get("frameCount") == "60") imgArray[4].changeImage("settingsButton.fr_60");
		if(Util.getAttr("kitsuneConfig").get("frameCount") == "30") imgArray[4].changeImage("settingsButton.fr_30");
		if(Util.getAttr("kitsuneConfig").get("frameCount") == "24") imgArray[4].changeImage("settingsButton.fr_24");

		if(Util.getAttr("kitsuneConfig").get("music") == "true") imgArray[5].changeImage("settingsButton.mus_t");
		if(Util.getAttr("kitsuneConfig").get("music") == "false") imgArray[5].changeImage("settingsButton.mus_f");
		if(Util.getAttr("kitsuneConfig").get("sfx") == "true") imgArray[6].changeImage("settingsButton.sfx_t");
		if(Util.getAttr("kitsuneConfig").get("sfx") == "false") imgArray[6].changeImage("settingsButton.sfx_f");
	}
	
	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN));
		g.drawString(Util.getString("EXASTART_TITLE"), (getScreenWidth() - 24) - g.font.font.getTextWidth(Util.getString("EXASTART_TITLE")), 12);
	}
}
