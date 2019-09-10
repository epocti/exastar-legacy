package scripts;

import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;
import nme.ui.Mouse;
import nme.display.Graphics;

class SE_c0_alien_lab extends SceneScript {
    public function new(dummy:Int, dummy2:Engine){ super(); }
	
	// ========
	
	override public function init(){
		if(Util.getFlag("metZeno") == "yes") removeRegion(getRegion(0).getID());
		if(Util.getFlag("zenoAtLaunchpad") == "yes") recycleActor(getActor(1));
		Script_Emotive.setAnim("zeno", "exhaust", "r", false, false);
		
		addKeyStateListener("action1", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void {
			if(pressed){
				if(isInRegion(getActor(2), getRegion(0)) && !Engine.engine.getGameAttribute("inDialog")){
					removeRegion(getRegion(0).getID());
					dialog.core.Dialog.cbCall("zenoChief_1", "style_main", this, "");
				}
			}
		});
	}
}
