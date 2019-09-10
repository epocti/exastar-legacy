package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;

class Script_ClearShaders extends SceneScript {
    public function new(dummy:Int, dummy2:Engine){ super(); }
	
	// ==== An entire script for this ====
	
	override public function init(){ engine.clearShaders(); }
}
