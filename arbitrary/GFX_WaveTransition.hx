package scripts.gfx;

import motion.Actuate;
import scripts.assets.Assets;
import com.stencyl.Engine;
import com.stencyl.behavior.TimedTask;
import scripts.tools.EZImgInstance;
import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.Script;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Expo;
import vixenkit.Tail;
import scripts.id.FontID;

class GFX_WaveTransition {
	var script:Script = new Script();
	var stakes:Array<EZImgInstance>;
	var mode:String = "in";
	var points:Array<Float> = new Array<Float>();

	public function new(){
		stakes = new Array<EZImgInstance>();
		for(i in 0...33) points.push(360);
		
		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			g.alpha = 1;
			g.strokeSize = 0;
			g.fillColor = Utils.getColorRGB(0,0,0);
			g.translateToScreen();
			if(mode == "in"){
				for(i in 0...32){
					g.beginFillPolygon();
					g.addPointToPolygon(i * 15, 360);
					g.addPointToPolygon(i * 15, points[i]);
					g.addPointToPolygon((i * 15) + 15, points[i + 1]);
					g.addPointToPolygon((i * 15) + 15, 360);
					g.endDrawingPolygon();
				}
			}
			else if(mode == "out"){
				for(i in 0...32){
					g.beginFillPolygon();
					g.addPointToPolygon(i * 15, 0);
					g.addPointToPolygon(i * 15, points[i]);
					g.addPointToPolygon((i * 15) + 15, points[i + 1]);
					g.addPointToPolygon((i * 15) + 15, 0);
					g.endDrawingPolygon();
				}
			}
			
		});
		
		Tail.log("Create wave transition", 1);
	}

	public function createIn():Void {
		Tail.log("Create wave transition in", 1);
		mode = "in";
		// Re-init all points to start at the bottom of the screen
		for(i in 0...33){
			points[i] = 360;
		}

		// Iterate over all points and slide them to the top of the screen
		var i:Int = 0;
		runPeriodically(33, function(timeTask:TimedTask):Void {
			if(i <= 33){
				Actuate.update(setPointValue, .66, [i, 360], [i, 0]).ease(Quad.easeOut);
			}
		 	i++;
		});
		
		playSoundOnChannel(Assets.get("sfx.transition"), 4);
	}

	public function createOut():Void {
		Tail.log("Create wave transition out", 1);
		mode = "out";
		// Re-init all points to start at the bottom of the screen
		for(i in 0...33){
			points[i] = 360;
		}

		// Iterate over all points and slide them to the top of the screen
		var i:Int = 0;
		runPeriodically(33, function(timeTask:TimedTask):Void {
			if(i <= 33){
				Actuate.update(setPointValue, .66, [i, 360], [i, 0]).ease(Quad.easeIn);
			}
		 	i++;
		});
		
		playSoundOnChannel(Assets.get("sfx.transition"), 4);
	}

	public function createInQuick():Void {
		Tail.log("Create quick wave transition in", 1);
		mode = "in";
		// Re-init all points to start at the bottom of the screen
		for(i in 0...33){
			points[i] = 360;
		}

		// Iterate over all points and slide them to the top of the screen
		var i:Int = 0;
		runPeriodically(20, function(timeTask:TimedTask):Void {
			if(i <= 33){
				Actuate.update(setPointValue, .4, [i, 360], [i, 0]).ease(Quad.easeOut);
			}
		 	i++;
		});
	}

	public function createOutQuick():Void {
		Tail.log("Create quick wave transition out", 1);
		mode = "out";
		// Re-init all points to start at the bottom of the screen
		for(i in 0...33){
			points[i] = 360;
		}

		// Iterate over all points and slide them to the top of the screen
		var i:Int = 0;
		runPeriodically(20, function(timeTask:TimedTask):Void {
			if(i <= 33){
				Actuate.update(setPointValue, .4, [i, 360], [i, 0]).ease(Quad.easeIn);
			}
		 	i++;
		});
	}

	function setPointValue(index:Float, newValue:Float):Void {
		points[Std.int(index)] = newValue;
	}
}