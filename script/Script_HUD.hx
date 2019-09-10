/*
	This script (C) 2018 Epocti.
	Description: Controls the creation and drawing of the HUD.
	Author: Kokoro
*/

package scripts;

import com.stencyl.behavior.TimedTask;
import motion.easing.Quad;
import scripts.tools.EZImgInstance;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;
import motion.Actuate;
import motion.easing.Linear;

class Script_HUD extends SceneScript {
	var ms:Int = 0;
	var opac:Float = 0;
	var backing:Array<EZImgInstance> = new Array<EZImgInstance>();
	var shadow:Array<EZImgInstance> = new Array<EZImgInstance>();
	var charImg:Array<EZImgInstance> = new Array<EZImgInstance>();
	var equipImg:Array<Array<EZImgInstance>> = new Array<Array<EZImgInstance>>();

	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		Util.enableStatOverlay();
		for(i in 0...Util.party().getMemberCount()){
			// init shadow
			shadow.push(new EZImgInstance("g", true, "ui.hud.shadow"));
			shadow[i].setXY(2, (i * 39) + 6);
			// init hud base
			backing.push(new EZImgInstance("g", true, "ui.hud.statusHud"));
			backing[i].setXY(4, (i * 39) + 4);
			// init char images
			charImg.push(new EZImgInstance("g", true, "ui.hud.face." + Util.party().getMember(i).getPcid() + ".0"));
			charImg[i].setXY(9, (i * 39) + 9);
			// init equipment images
			equipImg[i] = new Array<EZImgInstance>();
			equipImg[i].push(new EZImgInstance("g", true, "ui.menu.inv.item." + Util.party().getMember(i).getWeapon()));
			equipImg[i].push(new EZImgInstance("g", true, "ui.menu.inv.item." + Util.party().getMember(i).getDefense()));
			equipImg[i].push(new EZImgInstance("g", true, "ui.menu.inv.item." + Util.party().getMember(i).getCharm()));
			equipImg[i].push(new EZImgInstance("g", true, "ui.menu.inv.item." + Util.party().getMember(i).getMisc()));
			for(j in 0...4){
				equipImg[i][j].setXY(backing[i].getX() + 38 + (j * 21), backing[i].getY() + 20);
			}
		}
		immediateHudOut();
	}

	public inline function update(elapsedTime:Float){
		// Fade controller
		for(actorOfType in getActorsOfType(getActorTypeByName("char_alex"))){
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				if(actorOfType.getXVelocity() == 0 && actorOfType.getYVelocity() == 0) ms += 1;
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
			}
		}
		if(Util.statOverlayDisabled()) opac = 0;
		setHudAlpha(opac);
	}

	public inline function draw(g:G){
		g.setFont(getFont(613));
		g.alpha = (opac/100);
		g.strokeSize = 0;
		for(i in 0...Util.party().getMemberCount()){
			// HP
			g.fillColor = ColorConvert.getColorHSL((Util.party().getMember(i).getHp() / Util.party().getMember(i).getMaxHp()) * 120, 100, 100);
			g.fillRect(backing[i].getX() + 35, backing[i].getY() + 4, (Util.party().getMember(i).getHp() / Util.party().getMember(i).getMaxHp()) * 100, 7);
			g.drawString(Util.party().getMember(i).getHp() + "/" + Util.party().getMember(i).getHp(), backing[i].getX() + 37, backing[i].getY() + 5);
			// MP
			g.fillColor = ColorConvert.getColorHSL(-((Util.party().getMember(i).getMp() / Util.party().getMember(i).getMaxMp()) * 120) + 360, 100, 100);
			g.fillRect(backing[i].getX() + 35, backing[i].getY() + 12, (Util.party().getMember(i).getMp() / Util.party().getMember(i).getMaxMp()) * 100, 7);
			g.drawString(Util.party().getMember(i).getMp() + "/" + Util.party().getMember(i).getMp(), backing[i].getX() + 37, backing[i].getY() + 13);
		}
	}

	function setHudAlpha(alpha:Float){
		for(i in 0...Util.party().getMemberCount()){
			shadow[i].setAlpha(alpha);
			backing[i].setAlpha(alpha);
			charImg[i].setAlpha(alpha);
			for(j in 0...4){
				equipImg[i][j].setAlpha(alpha);
			}
		}
	}

	function slideHudIn(){
		for(i in 0...Util.party().getMemberCount()){
			runLater(i * 75, function(timeTask:TimedTask):Void {
				shadow[i].slideTo(2, (i * 39) + 6, .25, Quad.easeOut);
				backing[i].slideTo(4, (i * 39) + 4, .25, Quad.easeOut);
				charImg[i].slideTo(9, (i * 39) + 9, .25, Quad.easeOut);
				for(j in 0...4){
					equipImg[i][j].slideTo(41 + (j * 21), backing[i].getY() + 20, .25, Quad.easeOut);
				}
			}, null);
		}
	}

	function slideHudOut(){
		for(i in 0...Util.party().getMemberCount()){
			runLater(i * 75, function(timeTask:TimedTask):Void {
				shadow[i].slideTo(-138, (i * 39) + 6, .25, Quad.easeOut);
				backing[i].slideTo(-136, (i * 39) + 4, .25, Quad.easeOut);
				charImg[i].slideTo(-131, (i * 39) + 9, .25, Quad.easeOut);
				for(j in 0...4){
					equipImg[i][j].slideTo(-99 + (j * 21), backing[i].getY() + 20, .25, Quad.easeOut);
				}
			}, null);
		}
	}

	function immediateHudOut(){
		for(i in 0...Util.party().getMemberCount()){
			shadow[i].setXY(-138, (i * 39) + 6);
			backing[i].setXY(-136, (i * 39) + 4);
			charImg[i].setXY(-131, (i * 39) + 9);
			for(j in 0...4){
				equipImg[i][j].setXY(-99 + (j * 21), backing[i].getY() + 20);
			}
		}
	}
}
