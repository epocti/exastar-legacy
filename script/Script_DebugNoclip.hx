package scripts;

import scripts.tools.Util;
import box2D.dynamics.B2Fixture;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class Script_DebugNoclip extends ActorScript {
	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ==== hax ====

	override public function init(){}

	// Checks if the "a" key is down and if the game is in debug mode; if so, all collisions are changed to sensors; otherwise, all collisions will be normal
	public inline function update(elapsedTime:Float){
		if(Util.inDebugMode()){
			if(isKeyDown("a")){
				var shapeActor:Actor = actor;
				if (shapeActor.physicsMode == 0){
					var fixture:B2Fixture = shapeActor.getBody().getFixtureList();
					while (fixture != null){
						fixture.setSensor(true);
						fixture = fixture.getNext();
					}
				}
			}
			else if(isKeyReleased("a")){
				var shapeActor:Actor = actor;
				if (shapeActor.physicsMode == 0){
					var fixture:B2Fixture = shapeActor.getBody().getFixtureList();
					while (fixture != null){
						fixture.setSensor(false);
						fixture = fixture.getNext();
					}
				}
			}
		}
	}
}
