/*
	This script (C) 201X - 20XX Epocti.
	Description: 
	Author: 
*/

package scripts;

import scripts.tools.Util;
import scripts.assets.Assets;
import com.stencyl.Engine;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import dialog.core.Dialog;

class SE_c0_home_wakeup extends SceneScript {
	public function new(dummy:Int, dummy2:Engine){ super(); }

	// ========

	override public function init(){
		loopSound(Assets.get("sfx.phone_loop"));
		runLater(2000, function(timeTask:TimedTask):Void { Dialog.cbCall("dg_alexWakeupCall1", "style_main", this, "end"); }, null);
	}

	public function end():Void {
		runLater(2000, function(timeTask:TimedTask):Void {
			stopAllSounds();
			playSound(Assets.get("sfx.phone_pickup"));
			Util.setSceneState("in_alexHome1", 0);
			Util.switchSceneImmediate("in_alexHome1");
		}, null);
	}
}
