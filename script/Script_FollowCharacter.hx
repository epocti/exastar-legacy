package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.easing.Linear;
import scripts.tools.EZImgInstance;

class Script_FollowCharacter extends ActorScript {	
	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ==== e ====

	override public function init(){ Script_Emotive.setAnim(actor.getValue("Script_Emotive", "internalName"), "nf", "d", false, false); }

	public inline function update(elapsedTime:Float){
		Script_Emotive.setWalk(actor.getValue("Script_Emotive", "internalName"), Script_Emotive.getAnimWalkState("alex"));
		if(actor.getXVelocity() != 0 || actor.getYVelocity() != 0) {
			Script_Emotive.pointTowards(actor.getValue("Script_Emotive", "internalName"), getDir());
		}
	}

	function getDir():Float {
		return Utils.DEG * Math.atan2(actor.getYVelocity(), actor.getXVelocity());
	}
}