package scripts;

import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;

import scripts.tools.Util;
import scripts.tools.EZImgInstance;

class SE_init extends SceneScript {
	// var loaderImg:EZImgInstance = new EZImgInstance("engine/loaderImg.png", true);
    public function new(dummy:Int, dummy2:Engine){ super();	}
	
	// ========
	
	override public function init(){
		Util.switchSceneImmediate("preload");
	}
}
