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

import scripts.id.FontID;
import scripts.tools.Util;
import scripts.tools.EZImgInstance;
import scripts.gfx.particle.GFX_part;
import scripts.assets.Assets;

class SE_tbc extends SceneScript {
	var drawStep:Int = 0;
	var demoLogo:EZImgInstance = new EZImgInstance("g", true, "logo.exaLogoDemo");
	var covWidth:Int = 316;
	var particleEmitters:Array<GFX_part> = new Array<GFX_part>();
	var particlesMade:Bool = false;
	//var covRef:Int = 316;
	
	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// =====
	
	override public function init(){
		demoLogo.centerOnScreen(true, false);
		demoLogo.setY(180);

		runLater(2000, function(timeTask:TimedTask):Void {
			drawStep++;
			playSoundOnChannel(Assets.get("sfx.bttlAttack"), 0);
			SoundUtility.setPitchonChannelWithID(.8, 0);
			runLater(3000, function(timeTask:TimedTask):Void {
				drawStep++;
				playSoundOnChannel(Assets.get("sfx.bttlAttack"), 0);
				SoundUtility.setPitchonChannelWithID(.8, 0);
				runLater(3000, function(timeTask:TimedTask):Void {
					playSoundOnChannel(Assets.get("mus.actIntro"), 0);
					SoundUtility.setPitchonChannelWithID(.66, 0);
					Actuate.tween(this, 5, {covWidth:0}).ease(Quad.easeOut);
					// Particles
					particleEmitters.push(new GFX_part((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 22, "prt_abSparkle", 100, FRONT, true));
					particleEmitters.push(new GFX_part((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 29, "prt_abSparkle", 100, FRONT, true));
					runLater(50, function(timeTask:TimedTask):Void {
						particleEmitters.push(new GFX_part((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 35, "prt_abSparkle", 100, FRONT, true));
						particleEmitters.push(new GFX_part((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 42, "prt_abSparkle", 100, FRONT, true));
					}, null);
					runLater(100, function(timeTask:TimedTask):Void {
						particleEmitters.push(new GFX_part((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 48, "prt_abSparkle", 100, FRONT, true));
						particleEmitters.push(new GFX_part((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 56, "prt_abSparkle", 100, FRONT, true));
					}, null);
					particlesMade = true;
					// Disable particles
					runLater(3250, function(timeTask:TimedTask):Void { particleEmitters[0].disableEmission(); particleEmitters[1].disableEmission(); particleEmitters[4].disableEmission(); particleEmitters[5].disableEmission(); }, null);
					runLater(4000, function(timeTask:TimedTask):Void { for(emitter in particleEmitters) emitter.disableEmission(); }, null);
					// Switch scn
					Util.setAttr("bufferTransfer", "tbc_kokoScn");
					runLater(6500, function(timeTask:TimedTask):Void { switchScene(getIDForScene("buffer"), createFadeOut(2.5, Utils.getColorRGB(0,0,0))); }, null);
				}, null);
			}, null);
		}, null);
	}
	
	public inline function update(elapsedTime:Float){
		// Particle location
		if(particlesMade){
			particleEmitters[0].setXY((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 22);
			particleEmitters[1].setXY((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 29);
			runLater(50, function(timeTask:TimedTask):Void {
				particleEmitters[2].setXY((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 35);
				particleEmitters[3].setXY((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 42);
			}, null);
			runLater(100, function(timeTask:TimedTask):Void {
				particleEmitters[4].setXY((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 48);
				particleEmitters[5].setXY((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY() + 56);
			}, null);
		}
	}
	
	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.alpha = 1;
		if(drawStep >= 1) g.drawString("To Be Continued", Util.getMidScreenX() - (g.font.font.getTextWidth("To Be Continued") / 2), getScreenHeight() / 3);
		if(drawStep >= 2) g.drawString("in...", Util.getMidScreenX() - (g.font.font.getTextWidth("in...") / 2), getScreenHeight() / 2.5);
		g.strokeSize = 0;
		g.fillColor = Utils.getColorRGB(0, 0, 0);
		g.fillRect((demoLogo.getX() + demoLogo.getWidth()) - covWidth, demoLogo.getY(), covWidth, 88);
	}
}