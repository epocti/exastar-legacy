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

import scripts.tools.Util;
import scripts.tools.EZImgInstance;

class SE_bttl_end extends SceneScript {
	var textImg = new EZImgInstance("g", true, "ui.lvlup.text1");
	var bannerImg = new EZImgInstance("g", true, "ui.lvlup.banner");
	
	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ======
	
	override public function init(){
		textImg.setXY(3, 0);
		textImg.enableAnimation("ui.lvlup.text", 9, 66, true);
		runPeriodically(100, function(timeTask:TimedTask):Void {
			createRecycledActor(getActorType(792), randomInt(Util.getMidScreenX() - 33, Util.getMidScreenX() + 33), 0, Script.FRONT);
		}, null);
	}
	
	public inline function update(elapsedTime:Float){
	}
	
	public inline function draw(g:G){
	}
}