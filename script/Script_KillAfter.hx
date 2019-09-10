package scripts;

import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.Script;

class Script_KillAfter extends ActorScript {
	@:attribute("id='1' name='Time' desc='Time, in milliseconds, at which this actor should die after being created.'")
	public var time:Int = 0;
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }
	
	// ==== An entire script for 3 lines of code, cool ====
	
	override public function init(){
		runLater(time, function(timeTask:TimedTask):Void {
			recycleActor(actor);
		}, null);
	}
}