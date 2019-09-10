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
import scripts.Script_Emotive;

class SE_tbc_kokoScn extends SceneScript {
	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// =====
	
	override public function init(){
		playSoundOnChannel(Assets.get("sfx.stagelampClick"), 6);
		showTileLayer(0, "1");
		showTileLayer(0, "2");
		runLater(50, function(timeTask:TimedTask):Void {
			hideTileLayer(0, "1");
			hideTileLayer(0, "2");
			runLater(50, function(timeTask:TimedTask):Void {
				showTileLayer(0, "1");
				showTileLayer(0, "2");
				runLater(50, function(timeTask:TimedTask):Void {
					hideTileLayer(0, "1");
					hideTileLayer(0, "2");
					runLater(50, function(timeTask:TimedTask):Void {
						showTileLayer(0, "1");
						showTileLayer(0, "2");
					}, null);
				}, null);
			}, null);
		}, null);
		runLater(2500, function(timeTask:TimedTask):Void {
			Script_Emotive.setAnim("koko", "n", "d", true, false);
			getActor(1).moveBy(0, 250, 3, Linear.easeNone);
			runLater(3000, function(timeTask:TimedTask):Void {
				Script_Emotive.setAnim("koko", "n", "d", false, false);
				dialog.core.Dialog.cbCall("dg_tbcKoko", "style_main", this, "end");
			}, null);
		}, null);
	}
	
	public inline function update(elapsedTime:Float){
		
	}
	
	public inline function draw(g:G){
		
	}

	function end():Void {
		Script_Emotive.setAnim("koko", "n", "d", true, false);
		getActor(1).moveBy(0, -250, 3, Linear.easeNone);
		runLater(4000, function(timeTask:TimedTask):Void {
			hideTileLayer(0, "1");
			hideTileLayer(0, "2");
			runLater(50, function(timeTask:TimedTask):Void {
				showTileLayer(0, "1");
				showTileLayer(0, "2");
				runLater(50, function(timeTask:TimedTask):Void {
					hideTileLayer(0, "1");
					hideTileLayer(0, "2");
					runLater(50, function(timeTask:TimedTask):Void {
						showTileLayer(0, "1");
						showTileLayer(0, "2");
						runLater(50, function(timeTask:TimedTask):Void {
							hideTileLayer(0, "1");
							hideTileLayer(0, "2");
						}, null);
					}, null);
				}, null);
			}, null);
		}, null);
	}
}