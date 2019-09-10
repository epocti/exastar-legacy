package scripts;

import scripts.tools.Util;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;

class SE_c0_fest_wakeup extends SceneScript {
    public function new(dummy:Int, dummy2:Engine){ super(); }

	// ========

	public function dialogDone():Void {
		runLater(2000, function(timeTask:TimedTask):Void {
			switchScene(GameModel.get().scenes.get(getIDForScene("ow_18_42")).getID(), createFadeOut(0.01, Utils.getColorRGB(0,0,0)), createFadeIn(1.5, Utils.getColorRGB(0,0,0)));
		}, null);
	}

	override public function init(){
		Util.setSceneState("ow_18_42", 0);
		runLater(1000, function(timeTask:TimedTask):Void { dialog.core.Dialog.cbCall("spira_wakeup", "style_main", this, "dialogDone"); }, null);
	}
}
