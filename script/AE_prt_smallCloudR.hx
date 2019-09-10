package scripts;

import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import motion.easing.Linear;
import motion.easing.Quad;

class AE_prt_smallCloudR extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ========

	override public function init(){
		actor.moveBy(18, 0, .55, Quad.easeOut);
	}
}