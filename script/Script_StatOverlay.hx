package scripts;

import com.stencyl.utils.Utils;
import com.stencyl.behavior.TimedTask;
import motion.easing.Quad;
import scripts.id.FontID;
import scripts.tools.EZImgInstance;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import motion.Actuate;
import motion.easing.Linear;

class Script_StatOverlay extends ActorScript {
	var ms:Int = 0;
	var opac:Float = 0;
	var backing:Array<EZImgInstance> = new Array<EZImgInstance>();
	var shadow:Array<EZImgInstance> = new Array<EZImgInstance>();
	var charImg:Array<EZImgInstance> = new Array<EZImgInstance>();

	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		for(i in 0...Util.party().getMemberCount()){
			// init shadow
			shadow.push(new EZImgInstance("g", true, "ui.hud.shadow"));
			shadow[i].setXY(2, (i * 39) + 6);
			// init hud base
			backing.push(new EZImgInstance("g", true, "ui.hud.statusHud"));
			backing[i].setXY(4, (i * 39) + 4);
			// init char images
			// TODO: make hud-specific hud char images
			charImg.push(new EZImgInstance("g", true, "ui.titleMenu." + Util.party().getMember(i).getPcid()));
			charImg[i].setXY(15, (i * 39) + 14);
		}
		immediateHudOut();
	}

	public inline function update(elapsedTime:Float){
		// Fade controller
		if(actor.getXVelocity() == 0 && actor.getYVelocity() == 0) ms += 1;
		else {
			ms = 0;
			Actuate.tween(this, .2, {opac:0}).ease(Linear.easeNone);
			slideHudOut();
			if(opac <= 0) opac = 0;
		}
		if(ms >= 180){
			ms = 180;
			Actuate.tween(this, .2, {opac:100}).ease(Linear.easeNone);
			slideHudIn();
			if(opac >= 100) opac = 100;
		}
		setHudAlpha(opac);
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.alpha = 1;
		g.fillColor = Utils.getColorRGB(255, 255, 255);
		for(i in 0...Util.party().getMemberCount()){
			g.fillRect(backing[i].getX() + 36, backing[i].getY() + 4, 50, 14);
		}
	}

	function setHudAlpha(alpha:Float){
		for(i in 0...Util.party().getMemberCount()){
			shadow[i].setAlpha(alpha);
			backing[i].setAlpha(alpha);
			charImg[i].setAlpha(alpha);
		}
	}

	function slideHudIn(){
		for(i in 0...Util.party().getMemberCount()){
			runLater(i * 50, function(timeTask:TimedTask):Void {
				shadow[i].slideTo(2, (i * 39) + 6, .25, Quad.easeOut);
				backing[i].slideTo(4, (i * 39) + 4, .25, Quad.easeOut);
				charImg[i].slideTo(15, (i * 39) + 14, .25, Quad.easeOut);
			}, null);
		}
	}

	function slideHudOut(){
		for(i in 0...Util.party().getMemberCount()){
			runLater(i * 50, function(timeTask:TimedTask):Void {
				shadow[i].slideTo(-138, (i * 39) + 6, .25, Quad.easeOut);
				backing[i].slideTo(-136, (i * 39) + 4, .25, Quad.easeOut);
				charImg[i].slideTo(-125, (i * 39) + 14, .25, Quad.easeOut);
			}, null);
		}
	}

	function immediateHudOut(){
		for(i in 0...Util.party().getMemberCount()){
			shadow[i].setXY(-138, (i * 39) + 6);
			backing[i].setXY(-136, (i * 39) + 4);
			charImg[i].setXY(-125, (i * 39) + 14);
		}
	}
}