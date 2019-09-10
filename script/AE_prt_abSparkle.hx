package scripts;

import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import motion.easing.Linear;
import motion.easing.Quad;

class AE_prt_abSparkle extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ========

	override public function init(){
		actor.moveBy(-128, randomInt(-20, 20), 1.5, Quad.easeIn);
		runLater(1000, function(timeTask:TimedTask):Void {
			actor.fadeTo(0, .5, Linear.easeNone);
			runLater(500, function(timeTask:TimedTask):Void { recycleActor(actor); }, null);
		}, null);
	}
}