package scripts;

import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import motion.easing.Linear;
import motion.easing.Quad;

class AE_prt_waterSplashM extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ========

	override public function init(){
		var height:Int = randomInt(-25, -60);
		var xVelocity:Int = randomInt(-25, 25);
		actor.setAnimation("" + randomInt(0,7));
		
		actor.moveBy(xVelocity, height, .75, Quad.easeOut);
		runLater(750, function(timeTask:TimedTask):Void {
			actor.moveBy(xVelocity, -height, .75, Quad.easeIn);
			runLater(500, function(timeTask:TimedTask):Void { actor.fadeTo(0, .25, Linear.easeNone); }, null);
			runLater(750, function(timeTask:TimedTask):Void { recycleActor(actor); }, null);
		}, null);
	}
}