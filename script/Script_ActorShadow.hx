package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import motion.easing.Linear;
import scripts.tools.EZImgInstance;

class Script_ActorShadow extends ActorScript {
	//var shadowActor:Actor;
	var shadowImg:EZImgInstance;
	public var height:Int = 0;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
		nameMap.set("shadowActor", "shadowActor");
		nameMap.set("height", "height");
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ==== there are coffee stains on my desk from 1 week ago that i still haven't cleaned yet, lol ====

	override public function init(){
		// Make shadow
		shadowImg = new EZImgInstance("g", false, "gfx.shadow");
		shadowImg.attachToWorld("midbottom", actor.getX(), actor.getY(), 0);
		//shadowActor = createRecycledActorOnLayer(getActorType(497), actor.getXCenter(), (actor.getY() + (actor.getHeight())), 1, "midbottom");
		// Scale shadow
		shadowImg.setWidth(((actor.getWidth() / (shadowImg.getWidth())) * 100));
		shadowImg.setHeight((actor.getWidth() / shadowImg.getWidth() * 25));
		// Special scene checks to disable shadows
		if(getCurrentSceneName() == "c0_expositionEnd") hide();
		else if(getCurrentSceneName() == "c0_expositionEndIntro") hide();
	}

	public inline function update(elapsedTime:Float){
		// Position shadow
		shadowImg.setX(actor.getXCenter() - (shadowImg.getWidth() / 2));
		if(height == 0) shadowImg.setY(actor.getY() + (actor.getHeight() - (shadowImg.getHeight() / 2)));
		else shadowImg.setY(actor.getY() + ((actor.getHeight() + height) - (shadowImg.getHeight() / 2)));
		// Scale shadow
		//shadowImg.setWidth(((actor.getWidth() / (shadowImg.getWidth())) * 100));
		//shadowImg.setHeight((actor.getWidth() / shadowImg.getWidth() * 25));
	}

	public function reset():Void height = 0;
	public function hide():Void shadowImg.setAlpha(0);
	public function show():Void shadowImg.setAlpha(100);
}