package scripts.gfx.particle;

// Provides a reference and creation tool for particles, abstracting Stencyl's actor system.
// Think of this as an "emitter" of sorts.
// (special thanks to ezimginstance for taking up way too much memory and crashing the game every time we tried to garbage collect)

import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script;

class GFX_part {
	var particle:String;
	var x:Int;
	var y:Int;
	var emissionRate:Int;
	var layer:Int;
	var doEmit:Bool = true;

	public function new(x:Float, y:Float, particle:String, emissionRate:Float, layer:Float, enablePeriodicEmission:Bool){
		this.particle = particle;
		this.x = Std.int(x);
		this.y = Std.int(y);
		this.emissionRate = Std.int(emissionRate);
		this.layer = Std.int(layer);
		doEmit = enablePeriodicEmission;
		Script.createRecycledActor(Script.getActorTypeByName(this.particle), this.x, this.y, this.layer);
		emit();
	}

	public function emit(){
		// Work on emissionRate
		Script.runPeriodically(emissionRate, function(timeTask:TimedTask):Void { if(doEmit) Script.createRecycledActor(Script.getActorTypeByName(particle), x, y, layer); }, null);
	}

	public function setXY(x:Float, y:Float):Void {
		this.x = Std.int(x);
		this.y = Std.int(y);
	}
	public function enableEmission():Void { doEmit = true; }
	public function disableEmission():Void { doEmit = false; }
}