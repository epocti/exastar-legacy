package scripts;

import com.stencyl.models.GameModel;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.Engine;

class SE_c0_alien_sv_story extends SceneScript {
    public function new(dummy:Int, dummy2:Engine){ super(); }

	// ==== i remember when the game used to lock up on this screen for no reason, that was fun ====

	override public function init(){ runLater(2000, function(timeTask:TimedTask):Void { dialog.core.Dialog.cbCall("story_prologue", "style_prologue", this, "end"); }, null); }

	function end():Void { switchScene(GameModel.get().scenes.get(41).getID(), null, createCrossfadeTransition(0.01)); }
}