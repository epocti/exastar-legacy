package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class Script_BoundToScreen extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ==== nope, can't do that ====

	override public function init(){ actor.makeAlwaysSimulate(); }

	public inline function update(elapsedTime:Float){
		// Left of screen
		if(actor.getScreenX() < 0){
			actor.setX(getScreenX());
			actor.setXVelocity(0);
		}
		// Top of screen
		if(actor.getScreenY() < 0){
			actor.setY(getScreenY());
			actor.setYVelocity(0);
		}
		// Right of screen
		if(actor.getScreenX() + actor.getWidth() > getScreenWidth()){
			actor.setX(getScreenX() + (getScreenWidth() - actor.getWidth()));
			actor.setXVelocity(0);
		}
		// Bottom of screen
		if(actor.getScreenY() + actor.getHeight() > getScreenHeight()){
			actor.setY(getScreenY() + (getScreenHeight() - actor.getHeight()));
			actor.setYVelocity(0);
		}
	}
}