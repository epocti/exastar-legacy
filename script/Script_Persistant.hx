package scripts;

import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class Script_Persistant extends ActorScript {
    public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ==== An entire script for one line of code, cool ====
    
	override public function init(){ actor.makeAlwaysSimulate(); }
}
