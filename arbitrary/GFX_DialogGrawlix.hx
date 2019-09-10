package scripts.gfx;

import scripts.assets.Assets;
import motion.easing.Expo;
import com.stencyl.behavior.TimedTask;
import motion.easing.Quad;
import motion.Actuate;
import com.stencyl.Engine;
import scripts.id.FontID;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import scripts.tools.EZImgInstance;

class GFX_DialogGrawlix {
	var script:Script= new Script();
	var dialog:String = "Hello! My dialog is broken!";
	var duration:Float = 3.0;
	var opac:Float = 0;
	var img:EZImgInstance;

	public function new(dialog:String, duration:Float, initX:Int, initY:Int){
		this.dialog = dialog;
		this.duration = duration;
		img = new EZImgInstance("g", true, "gfx.grawlix_dialog");
		img.setAlpha(0);
		img.setXY(initX, initY);
		if(((Script.getFont(FontID.MAIN).font.getTextWidth(dialog)/Engine.SCALE * 100) / 72) + 30 > 72) img.setWidth(Std.int((Script.getFont(FontID.MAIN).font.getTextWidth(dialog)/Engine.SCALE * 100) / 72) + 30);
		img.fadeTo(100, .25, Quad.easeOut);
		img.slideBy(0, -3, .25, Expo.easeOut);
		Actuate.tween(this, .25, {opac:100}).ease(Quad.easeOut);
		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			g.setFont(Script.getFont(FontID.MAIN));
			g.alpha = (opac / 100);
			g.drawString(dialog, img.getX() + (img.getWidth() / 2) - (g.font.font.getTextWidth(dialog) / 2), img.getY() + 3);
		});
		Script.runLater(duration, function(timeTask:TimedTask):Void {
			img.fadeTo(0, .25, Quad.easeOut);
			img.slideBy(0, 3, .25, Expo.easeOut);
			Actuate.tween(this, .25, {opac:0}).ease(Quad.easeOut);
		}, null);
	}
}
