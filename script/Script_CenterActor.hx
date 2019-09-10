package scripts;

import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import scripts.tools.Util;

class Script_CenterActor extends ActorScript {
	@:attribute("id='1' name='Center on X axis' desc=''")
	public var centerX:Bool = true;
	@:attribute("id='2' name='Center on Y axis' desc=''")
	public var centerY:Bool = true;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ==== i cant think of anything funny to write here... but this script centers an actor, i guess thats pretty funny ====

	override public function init(){
		if(centerX) actor.setX(Util.getMidScreenX() - (actor.getWidth() / 2));
		if(centerY) actor.setY(Util.getMidScreenY() - (actor.getHeight() / 2));
	}
}