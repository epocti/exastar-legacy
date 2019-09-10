package scripts;

import scripts.assets.Assets;
import scripts.id.FontID;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.Actuate;
import motion.easing.Linear;
import motion.easing.Quad;

class SE_c0_owIntro_land extends SceneScript {
    var opac:Float = 0;
	var textY:Int = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		textY = Std.int(Util.getMidScreenY() + 18);
		// Move text up
		runLater(3000, function(timeTask:TimedTask):Void {
			Actuate.tween(this, 1.5, {opac:100}).ease(Linear.easeNone);
			Actuate.tween(this, 1.5, {textY:Util.getMidScreenY()}).ease(Quad.easeOut);
		}, null);
		// Move text down
		runLater(8000, function(timeTask:TimedTask):Void {
			Actuate.tween(this, 1.5, {opac:0}).ease(Linear.easeNone);
			Actuate.tween(this, 1.5, {textY:(Util.getMidScreenY() + 18)}).ease(Quad.easeIn);
		}, null);
		// SFX
		runPeriodically(1750, function(timeTask:TimedTask):Void {
				SoundUtility.setPitchonAllChannels(randomFloatBetween(.6, 1.1));
				playSound(Assets.get("mus.shore"));
		}, null);
		// End switch
		runLater(10000, function(timeTask:TimedTask):Void {
			switchScene(GameModel.get().scenes.get(78).getID(), createFadeOut(2, Utils.getColorRGB(0,0,0)), createFadeIn(2, Utils.getColorRGB(0,0,0)));
		}, null);
	}

	public inline function draw(g:G){
		g.alpha = (opac/100);
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.drawString(Util.getString("LANDINTRO_BLUEMOSE"), Util.getMidScreenX() - (g.font.font.getTextWidth(Util.getString("LANDINTRO_BLUEMOSE")) / 2), textY);
	}
}
