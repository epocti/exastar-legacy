package scripts;

import com.stencyl.graphics.shaders.ExternalShader;
import scripts.tools.EZImgInstance;
import scripts.tools.Util;
import scripts.assets.Assets;
import com.stencyl.Data;
import scripts.gfx.GFX_DialogGrawlix;
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
import scripts.ui.UI_ItemGet;
import scripts.vixenkit.TwineInterpreter;

class SE_test12 extends SceneScript {
	// var zoomShader = new ExternalShader("gfx/shader/zoom.glsl");
	// var reflectionImgs:Array<EZImgInstance> = new Array<EZImgInstance>();

    public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ==== a playground to test all of the coolest features that won't get implemented any time soon ====
	
	override public function init(){
		TwineInterpreter.run("twn/test.vkt");
		loopSoundOnChannel(Assets.get("mus.forest"), 0);
		
		//runLater(1000, function(timeTask:TimedTask){ dialog.core.Dialog.cbCall("dg_fest_samHelp", "style_main", this, ""); }, null);
		// engine.toggleShadersForHUD();
		// zoomShader.enable();

		// Test quest adding
		/*
		runPeriodically(5000, function(timeTask:TimedTask):Void {
			Util.quests().add("test");
			Util.party().getMember(0).setXp(Util.party().getMember(0).getXp() + 20);
		}, null); */
		
		// Test reflections
		/*
		for(actorType in getAllActorTypes()){
			for(actor in getActorsOfType(actorType)){
				reflectionImgs.push(new EZImgInstance(null, false, 0, 0, actor));
				reflectionImgs[reflectionImgs.length - 1].attachToWorld("midbottom", actor.getX(), actor.getY(), 0);
				reflectionImgs[reflectionImgs.length - 1].setY(actor.getY() + actor.getHeight());
				reflectionImgs[reflectionImgs.length - 1].setOrigin("CENTER");
				reflectionImgs[reflectionImgs.length - 1].spinTo(180, 0.01, null);
				reflectionImgs[reflectionImgs.length - 1].setAlpha(20);
			}
		} */
	}
	
	public inline function update(elapsedTime:Float){
	}
	
	public inline function draw(g:G){
	}
}
