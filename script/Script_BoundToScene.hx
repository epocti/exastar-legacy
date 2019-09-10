package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class Script_BoundToScene extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ========

	override public function init(){ actor.makeAlwaysSimulate(); }

	public inline function update(elapsedTime:Float){
		// Left bound
		if(actor.getX() < 0){
			actor.setX(0);
			actor.setXVelocity(0);
		}
		// Top scene bound checks based on typical collision height
		if(actor.getY() + ((actor.getHeight() / 5) * 3) < 0){
			actor.setY(0);
			actor.setYVelocity(0);
		}
		// Right bound
		if(actor.getX() + actor.getWidth() > getSceneWidth()){
			actor.setX(getSceneWidth() - actor.getWidth());
			actor.setXVelocity(0);
		}
		// Bottom bound
		if(actor.getY() + actor.getHeight() > getSceneHeight()){
			actor.setY(getSceneHeight() - actor.getHeight());
			actor.setYVelocity(0);
		}
	}
}