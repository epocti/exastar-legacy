package scripts;

import scripts.tools.Util;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;

class SE_c0_alien_hallway extends SceneScript {
    public function new(dummy:Int, dummy2:Engine){ super(); }
	
	// ========
	
	override public function init(){ /* if(Util.getAttr("activeParty").contains(-2)) createRecycledActor(getActorType(405), getActor(1).getX(), getActor(1).getY(), Script.MIDDLE); */ }
}
