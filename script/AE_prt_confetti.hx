package scripts;

import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import motion.easing.Linear;
import motion.easing.Quad;

class AE_prt_confetti extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ========

	override public function init(){
		var xVelocity:Int = randomInt(-50, 50);
		actor.setAnimation("" + randomInt(0,4));
		actor.setFilter([createTintFilter(ColorConvert.getColorHSL(randomInt(0, 360), 255, 190), 1)]);
		
		actor.moveBy(xVelocity, randomInt(290, 340), 2, Linear.easeNone);
		runLater(2000, function(timeTask:TimedTask):Void {
			actor.setAnimation("static");
			runLater(2000, function(timeTask:TimedTask):Void { actor.fadeTo(0, .5, Linear.easeNone); }, null);
			runLater(2501, function(timeTask:TimedTask):Void { recycleActor(actor); }, null);
		}, null);
	}
}