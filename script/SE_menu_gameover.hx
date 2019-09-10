package scripts;

import scripts.assets.Assets;
import scripts.saves.SaveManager;
import scripts.gfx.GFX_StakeTransition;
import motion.easing.Linear;
import scripts.tools.Util;
import com.stencyl.behavior.TimedTask;
import openfl.events.KeyboardEvent;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import scripts.id.FontID;

class SE_menu_gameover extends SceneScript {
	var sel:Int = 0;
	var transitioning:Bool = false;

    public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		loopSoundOnChannel(Assets.get("mus.gameover"), 0);
		Script_Emotive.setAnim("alex", "sitdownGO", "d", false, false);
		Util.disableMovement();
		Util.disableStatOverlay();
		runLater(1, function(timeTask:TimedTask):Void { getActor(1).setValue("Script_ActorShadow", "height", -4); }, null);

		// Keypress listener
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(isKeyPressed("action1")){
				if(sel == 0 && !transitioning){
					transitioning = true;
					Script_Emotive.setAnim("alex", "sitdownHSGO", "d", false, false);
					runLater(800, function(timeTask:TimedTask):Void {
						fadeOutSoundOnChannel(0, 5);
						getActor(1).setValue("Script_ActorShadow", "height", 0);
						Script_Emotive.setAnim("alex", "n", "d", false, false);
						runLater(120, function(timeTask:TimedTask):Void {
							Script_Emotive.setAnim("alex", "n", "dl", false, false);
							runLater(120, function(timeTask:TimedTask):Void {
								Script_Emotive.setAnim("alex", "n", "l", true, false);
								getActor(1).moveBy(-130, 0, 1.25, Linear.easeNone);
							}, null);
						}, null);
					}, null);
					runLater(2750, function(timeTask:TimedTask):Void {
						Util.setAttr("isTransitioning", true);
						var trans:GFX_StakeTransition = new GFX_StakeTransition();
						trans.createIn();
						runLater(5000, function(timeTask:TimedTask):Void {
							// TODO: this should be used in release: SaveManager.LoadFile(Util.getCurrentFile());
							stopSoundOnChannel(0);
							SaveManager.LoadFile(0);
							Util.switchSceneImmediate(Util.getAttr("savedLocation"));
						}, null);
					}, null);
					runLater(5999, function(timeTask:TimedTask):Void {
						Util.enableMovement();
						Util.enableStatOverlay();
						Script_Emotive.setAnim("alex", "n", "d", false, false);
					}, null);
				}
				else if(sel == 1 && !transitioning){
					transitioning = true;
					// Reload just in case the exit command fails to execute for some reason
					reloadCurrentScene(createFadeOut(5, Utils.getColorRGB(0,0,0)));
					fadeOutSoundOnChannel(0, 5);
					runLater(4875, function(task:TimedTask):Void {
						stopSoundOnChannel(0);
						Util.exitGame();
					});
					playSoundOnChannel(Assets.get("sfx.old.ui_menuSwitch_old"), 31);
				}
			}
			if((isKeyPressed("down") || isKeyPressed("up")) && !transitioning){
				if(sel == 0) sel = 1;
				else sel = 0;
			}
		});
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN_WHITE));
		//if(!Util.getAttr("isTransitioning")){
			g.drawString(Util.getString("GAMEOVER_CONTINUE"), 303, 287);
			g.drawString(Util.getString("GAMEOVER_END"), 303, 300);
			if(sel == 0) g.drawString("^", 290, 287);
			else if(sel == 1) g.drawString("^", 290, 300);
		//}
	}
}