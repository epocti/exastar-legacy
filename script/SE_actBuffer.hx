package scripts;

import scripts.assets.Assets;
import scripts.gfx.particle.GFX_part;
import scripts.id.FontID;
import scripts.tools.EZImgInstance;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.Actuate;
import motion.easing.Linear;
import motion.easing.Quad;

class SE_actBuffer extends SceneScript {
	var actImage:EZImgInstance = new EZImgInstance("g", false, "cutscene.actBuffer.c0a2");
	var chapterAct:String = "Chapter 0, Act 2";
	var actTitle:String = "A Crash Landing";
	var sq1w:Int = getFont(FontID.MAIN_WHITE).font.getTextWidth("Chapter 0, Act 2");
	var sq2w:Int = getFont(FontID.MAIN_WHITE).font.getTextWidth("A Crash Landing");
	var particleEmitters:Array<GFX_part> = new Array<GFX_part>();

	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========
	
	override public function init(){
		playSoundOnChannel(Assets.get("mus.actIntro"), 0);
		// Act image
		actImage.attachToWorld("img", 0, 0, BACK);
		actImage.setAlpha(0);
		actImage.fadeIn(2, Linear.easeNone);

		Actuate.tween(this, 3, {sq1w:0}).ease(Quad.easeOut);
		Actuate.tween(this, 3, {sq2w:0}).ease(Quad.easeOut);

		// Particles
		particleEmitters.push(new GFX_part(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(chapterAct) / 2)) - sq1w, 35, "prt_abSparkle", 100, FRONT, true));
		particleEmitters.push(new GFX_part(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(actTitle) / 2)) - sq2w, 71, "prt_abSparkle", 100, FRONT, true));
		runLater(25, function(timeTask:TimedTask):Void {
			particleEmitters.push(new GFX_part(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(chapterAct) / 2)) - sq1w, 37, "prt_abSparkle", 100, FRONT, true));
			particleEmitters.push(new GFX_part(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(actTitle) / 2)) - sq2w, 73, "prt_abSparkle", 100, FRONT, true));
		}, null);
		runLater(50, function(timeTask:TimedTask):Void {
			particleEmitters.push(new GFX_part(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(chapterAct) / 2)) - sq1w, 39, "prt_abSparkle", 100, FRONT, true));
			particleEmitters.push(new GFX_part(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(actTitle) / 2)) - sq2w, 75, "prt_abSparkle", 100, FRONT, true));
		}, null);
		// Disable particles
		runLater(2550, function(timeTask:TimedTask):Void { for(emitter in particleEmitters) emitter.disableEmission(); }, null);
	}
	
	public inline function update(elapsedTime:Float){
		// Particle location
		particleEmitters[0].setXY(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(chapterAct) / 2)) - sq1w, 35);
		particleEmitters[1].setXY(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(actTitle) / 2)) - sq2w, 71);
		runLater(25, function(timeTask:TimedTask):Void {
			particleEmitters[2].setXY(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(chapterAct) / 2)) - sq1w, 37);
			particleEmitters[3].setXY(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(actTitle) / 2)) - sq2w, 73);
		}, null);
		runLater(50, function(timeTask:TimedTask):Void {
			particleEmitters[4].setXY(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(chapterAct) / 2)) - sq1w, 39);
			particleEmitters[5].setXY(((getScreenWidth() / 2) + (getFont(FontID.MAIN_WHITE).font.getTextWidth(actTitle) / 2)) - sq2w, 75);
		}, null);
	}
	
	public inline function draw(g:G){
		// Text/reveal drawing
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.drawString(chapterAct, (getScreenWidth() / 2) - (g.font.font.getTextWidth(chapterAct) / 2), 31);
		g.drawString(actTitle, (getScreenWidth() / 2) - (g.font.font.getTextWidth(actTitle) / 2), 67);
		g.fillColor = Utils.getColorRGB(0, 0, 0);
		g.fillRect(((getScreenWidth() / 2) + (g.font.font.getTextWidth(chapterAct) / 2)) - sq1w, 29, sq1w, 17);
		g.fillRect(((getScreenWidth() / 2) + (g.font.font.getTextWidth(actTitle) / 2)) - sq2w, 65, sq2w, 17);
		g.fillRect(((getScreenWidth() / 2) + (g.font.font.getTextWidth(chapterAct) / 2)) - sq1w, 29, 32, 17);
		g.fillRect(((getScreenWidth() / 2) + (g.font.font.getTextWidth(actTitle) / 2)) - sq2w, 65, 32, 17);
	}
}