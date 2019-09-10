package scripts.gfx;

import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.models.GameModel;
import motion.Actuate;
import motion.easing.Linear;
import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script;
import com.stencyl.utils.Utils;
import scripts.tools.Util;
import com.stencyl.models.actor.Group;

class GFX_BattleTransition {
	var script:Script = new Script();
	var transition:GFX_WaveTransition = new GFX_WaveTransition();
	var opac:Float = 0;
	//var transitioning:Bool = false;

	public function new(){
		for(actorInGroup in cast(Script.getActorGroup(0), Group).list){
			if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled)
				actorInGroup.currAnimation.setFrameDuration(actorInGroup.getCurrentFrame(), 3000);
		}
		Util.disableStatOverlay();
		Util.enableInDialog();
		Script.runLater(1500, function(timeTask:TimedTask):Void { transition.createInQuick(); });
		Actuate.tween(this, 1, {opac:33}).ease(Linear.easeNone);
		Script.runLater(2850, function(timeTask:TimedTask):Void { Actuate.tween(this, .1, {opac:0}).ease(Linear.easeNone); });
		Script.runLater(3000, function(timeTask:TimedTask):Void {
			Util.switchSceneImmediate("bttlScn");
		});

		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			g.translateToScreen();
			g.strokeSize = 0;
			g.fillColor = Utils.getColorRGB(255, 0, 0);
			g.alpha = (opac/100);
			g.fillRect(0, 0, Script.getScreenWidth(), Script.getScreenHeight());
		});
	}
}
