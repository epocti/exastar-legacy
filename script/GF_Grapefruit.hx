package scripts;

import com.stencyl.Engine;
import scripts.tools.EZImgInstance;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import openfl.events.KeyboardEvent;
import scripts.grapefruit.GF_EnemyContainer;

class GF_Grapefruit extends SceneScript {
	var rainbowH:Int = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();
	}

	// ==== the engine rewrite to end all engine rewrites: PREPARE YOURSELF ====
	// for comparison, the original grapefruit was 1200 lines of code (at least when incomplete)

	override public function init(){
	}
}