package scripts;

import scripts.tools.Util;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class Script_CameraFollow extends ActorScript {
	var cameraX:Float;
	var cameraY:Float;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ========
	
	override public function init(){
		// Set camera location X/Y, and update
		if(Util.cameraSnappingEnabled()){
			cameraX = actor.getXCenter();
			cameraY = actor.getYCenter();
			engine.moveCamera(cameraX, cameraY);
		}
	}

	public inline function update(elapsedTime:Float){
		// Set camera location X/Y, and update
		if(Util.cameraSnappingEnabled()){
			cameraX = actor.getXCenter();
			cameraY = actor.getYCenter();
			engine.moveCamera(cameraX, cameraY);
		}
	}
}