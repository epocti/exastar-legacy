package scripts;

import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class AE_abg_title1 extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	override public function init(){ actor.setXVelocity(-6); }

	public inline function update(elapsedTime:Float){
		if(actor.getX() == -1440 && actor.getY() == 0){
			actor.setXVelocity(6);
			actor.setYVelocity(-4);
		}
		else if(actor.getX() == 0 && actor.getY() <= -800){
			actor.setXVelocity(-6);
			actor.setYVelocity(0);
		}
		else if(actor.getX() == -1440 && actor.getY() <= -800){
			actor.setXVelocity(6);
			actor.setYVelocity(4);
		}
		else if(actor.getX() == 0 && actor.getY() >= -799){
			actor.setXVelocity(-6);
			actor.setYVelocity(0);
		}
	}
}