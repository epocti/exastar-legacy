package scripts.gfx;

import scripts.assets.Assets;
import com.stencyl.Engine;
import com.stencyl.behavior.TimedTask;
import scripts.tools.EZImgInstance;
import com.stencyl.behavior.Script.*;
import motion.easing.Quad;
import vixenkit.Tail;

class GFX_StakeTransition {
	var stakes:Array<EZImgInstance>;

	public function new(){
		stakes = new Array<EZImgInstance>();
		Tail.log("Create stake transition", 1);
	}

	public function createIn():Void {
		Tail.log("Create stake transition in", 1);
		playSoundOnChannel(Assets.get("sfx.transition"), 4);
		runPeriodically(75, function(timeTask:TimedTask):Void {
			if(stakes.length <= 15){
				stakes.push(new EZImgInstance("g", true, "gfx.stakeTransition"));	
				stakes[stakes.length - 1].sendToFront();
				stakes[stakes.length - 1].setXY((stakes.length - 1) * 32, 480);
				stakes[stakes.length - 1].slideBy(0, -496, .75, Quad.easeOut);
			}
		});
	}

	public function createOut():Void {
		Tail.log("Create stake transition out", 1);
		playSoundOnChannel(Assets.get("sfx.transition"), 4);
		for(i in 0...15){
			stakes.push(new EZImgInstance("g", true, "gfx.stakeTransition"));
			stakes[i].sendToFront();
			stakes[i].flipVertical();
			stakes[i].setXY(i * 32, 0);
		}
		var stakeNum:Int = 0;
		runPeriodically(75, function(timeTask:TimedTask):Void {
			if(stakeNum <= 14){
				stakes[stakeNum].slideBy(0, -496, .75, Quad.easeOut);
				stakeNum++;
			}
		});
	}

	public function createInQuick():Void {
		Tail.log("Create quick stake transition in", 1);
		//playSoundOnChannel(Assets.get("sfx.transition"), 4);
		runPeriodically(50, function(timeTask:TimedTask):Void {
			if(stakes.length <= 15){
				stakes.push(new EZImgInstance("g", true, "gfx.stakeTransition"));	
				stakes[stakes.length - 1].sendToFront();
				stakes[stakes.length - 1].setXY((stakes.length - 1) * 32, 480);
				stakes[stakes.length - 1].slideBy(0, -496, .55, Quad.easeOut);
			}
		});
	}

	public function createOutQuick():Void {
		Tail.log("Create quick stake transition out", 1);
		//playSoundOnChannel(Assets.get("sfx.transition"), 4);
		for(i in 0...15){
			stakes.push(new EZImgInstance("g", true, "gfx.stakeTransition"));
			stakes[i].sendToFront();
			stakes[i].flipVertical();
			stakes[i].setXY(i * 32, 0);
		}
		var stakeNum:Int = 0;
		runPeriodically(50, function(timeTask:TimedTask):Void {
			if(stakeNum <= 14){
				stakes[stakeNum].slideBy(0, -496, .55, Quad.easeOut);
				stakeNum++;
			}
		});
	}
}