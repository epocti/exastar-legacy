package scripts.gfx;

import motion.Actuate;
import motion.easing.Expo;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.utils.Utils;

class GFX_Letterbox {
	var script:Script = new Script();
	var size:Int;

	public function new(slideIn:Bool){
		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			g.alpha = 1;
			g.strokeSize = 0;
			g.fillColor = Utils.getColorRGB(0,0,0);
			g.fillRect(0, 0, 480, size);
			g.fillRect(0, Script.getScreenHeight() - size, 480, size);
		});
		if(slideIn) Actuate.tween(this, .5, {size:45}).ease(Expo.easeOut);
		else size = 45;
	}
	public function show():Void { Actuate.tween(this, .5, {size:45}).ease(Expo.easeIn); }
	public function hide():Void { Actuate.tween(this, .5, {size:0}).ease(Expo.easeIn); }
}
