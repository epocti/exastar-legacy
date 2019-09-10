package scripts;

import scripts.tools.Util;
import scripts.gfx.TileTransition;
import scripts.scene.SceneBoundListener;
import scripts.game.DialogZone;
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
import scripts.game.PremadeDialogZone;
import scripts.tools.Util;

class SE_ow_7_52 extends SceneScript {

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ========
	
	override public function init(){
		if(Util.getCurrentSceneState() == 0){
			Util.setFlag("keriiDisregardState", 0);
			Util.disableMovement();
			runLater(2000, function(timeTask:TimedTask){
				dialog.core.Dialog.cbCall("dg_keriiIntro_saving", "style_main", this, "endInitDg");
			}, null);
		}
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void {
			if(Script.sameAsAny(Script.getActorGroup(0),a.getType(),a.getGroup())){
				Util.disableMovement();
				removeRegion(getRegion(0).getID());
				dialog.core.Dialog.cbCall("dg_keriiIntro_savingDisregard", "style_main", this, "endDisregardDg");
				Util.setFlag("keriiDisregardState", 1);
			}
		});
	}
	
	public inline function update(elapsedTime:Float){
		
	}
	
	function endInitDg():Void {
		Util.setCurrentSceneState(1);
	}

	function endDisregardDg():Void {
		//Util.setCurrentSceneState(2);
	}

	public function onGameSave():Void {
		if(Util.getCurrentSceneState() <= 1){
			Util.setFlag("keriiDisregardState", 0);
			runLater(100, function(timeTask:TimedTask){
				dialog.core.Dialog.cbCall("dg_keriiIntro_savingComplete", "style_main", this, "endInitDg");
			}, null);
			Util.disableMovement();
			if(getRegion(0) != null) removeRegion(getRegion(0).getID());
			Util.setCurrentSceneState(2);
		}
		
	}
}